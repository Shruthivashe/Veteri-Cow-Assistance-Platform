<%-- 
    Document   : notifications
    Created on : 8 Aug 2025, 7:03:22 pm
    Author     : User
--%>

<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Notifications - Vaccine Reminders</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f4ff;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            box-shadow: 0 0 15px rgba(0, 50, 150, 0.1);
            border-radius: 10px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        .section-title {
            color: #1e40af;
            font-size: 18px;
            margin-top: 30px;
            border-bottom: 2px solid #c7d2fe;
            padding-bottom: 5px;
        }

        .notification {
            border: 1px solid #d6e4ff;
            margin-top: 10px;
            padding: 15px;
            border-radius: 6px;
            color: #1f2937;
        }

        .overdue {
            border-left: 5px solid #ef4444;
            background-color: #fff1f2;
        }

        .upcoming {
            border-left: 5px solid #3b82f6;
            background-color: #e0f2fe;
        }

        .notification span {
            font-weight: bold;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        button {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .clear-btn {
            background-color: #ef4444;
            color: white;
        }

        .clear-btn:hover {
            background-color: #dc2626;
        }

        .back-btn {
            background-color: #3b82f6;
            color: white;
        }

        .back-btn:hover {
            background-color: #2563eb;
        }

        .no-notification {
            text-align: center;
            color: gray;
            font-style: italic;
            margin-top: 20px;
        }
    </style>

    <script>
        function clearNotifications() {
            const sections = document.querySelectorAll(".section-title, .notification");
            sections.forEach(el => el.remove());

            const message = document.createElement("div");
            message.className = "no-notification";
            message.innerText = "✅ All notifications cleared from screen.";
            document.querySelector(".container").insertBefore(message, document.querySelector(".buttons"));
        }
    </script>
</head>
<body>
<div class="container">
    <h2>🔔 Vaccine Notifications</h2>

    <%
        String dbURL = "jdbc:mysql://localhost:3306/mysql";
        String dbUser = "root";
        String dbPass = "Root@123";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        boolean hasOverdue = false;
        boolean hasUpcoming = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");

            // Overdue
            String overdueQuery = "SELECT * FROM vaccine_tracking WHERE due_date <= CURDATE() ORDER BY due_date ASC";
            stmt = conn.prepareStatement(overdueQuery);
            rs = stmt.executeQuery();

            if (rs.isBeforeFirst()) {
    %>
                <div class="section-title">❗ Overdue Vaccines</div>
    <%
                while (rs.next()) {
                    hasOverdue = true;
                    String cattleId = rs.getString("cattle_id");
                    String vaccineName = rs.getString("vaccine_name");
                    java.sql.Date dueDate = rs.getDate("due_date");
    %>
                    <div class="notification overdue">
                        Vaccine <span><%= vaccineName %></span> was due for Cattle ID: <span><%= cattleId %></span> on <span><%= sdf.format(dueDate) %></span>.
                    </div>
    <%
                }
            }
            rs.close();
            stmt.close();

            // Upcoming
            String upcomingQuery = "SELECT * FROM vaccine_tracking WHERE due_date > CURDATE() AND due_date <= DATE_ADD(CURDATE(), INTERVAL 3 DAY) ORDER BY due_date ASC";
            stmt = conn.prepareStatement(upcomingQuery);
            rs = stmt.executeQuery();

            if (rs.isBeforeFirst()) {
    %>
                <div class="section-title">📅 Upcoming in Next 3 Days</div>
    <%
                while (rs.next()) {
                    hasUpcoming = true;
                    String cattleId = rs.getString("cattle_id");
                    String vaccineName = rs.getString("vaccine_name");
                    java.sql.Date dueDate = rs.getDate("due_date");
    %>
                    <div class="notification upcoming">
                        Vaccine <span><%= vaccineName %></span> is due for Cattle ID: <span><%= cattleId %></span> on <span><%= sdf.format(dueDate) %></span>.
                    </div>
    <%
                }
            }
            rs.close();
            stmt.close();
            conn.close();

            if (!hasOverdue && !hasUpcoming) {
    %>
                <div class="no-notification">🎉 No upcoming or overdue vaccines! You're all set.</div>
    <%
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>

    <div class="buttons">
        <button type="button" class="clear-btn" onclick="clearNotifications()">🗑️ Clear All</button>
        <form action="user_dashboard.jsp">
            <button type="submit" class="back-btn">🔙 Go Back</button>
        </form>
    </div>
</div>
</body>
</html>
