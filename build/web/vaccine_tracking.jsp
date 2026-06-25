<%-- 
    Document   : vaccine_tracking
    Created on : 8 Aug 2025, 7:40:22 pm
    Author     : User
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    String vet = (String) session.getAttribute("user");
    if (vet == null) {
        response.sendRedirect("vet_login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        // Handle deletion
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            ps = conn.prepareStatement("DELETE FROM vaccine_tracking WHERE id=? AND vet_username=?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.setString(2, vet);
            ps.executeUpdate();
        }

        // Handle insertion
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String cattleId = request.getParameter("cattle_id");
            String vaccineName = request.getParameter("vaccine_name");
            String dueDate = request.getParameter("due_date");

            if (cattleId != null && vaccineName != null && dueDate != null) {
                ps = conn.prepareStatement("INSERT INTO vaccine_tracking (vet_username, cattle_id, vaccine_name, due_date) VALUES (?, ?, ?, ?)");
                ps.setString(1, vet);
                ps.setString(2, cattleId);
                ps.setString(3, vaccineName);
                ps.setDate(4, java.sql.Date.valueOf(dueDate));
                ps.executeUpdate();
            }
        }

        ps = conn.prepareStatement("SELECT * FROM vaccine_tracking WHERE vet_username = ? ORDER BY due_date ASC");
        ps.setString(1, vet);
        rs = ps.executeQuery();

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vaccine Tracking</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #e3f2fd;
            color: #333;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #1976d2;
        }
        .back-btn {
            display: inline-block;
            background: #1565c0;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            margin-bottom: 20px;
        }
        form {
            max-width: 600px;
            margin: 0 auto 30px auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background: #0288d1;
            color: white;
            border: none;
            padding: 10px 16px;
            margin-top: 15px;
            border-radius: 6px;
            cursor: pointer;
        }
        table {
            width: 100%;
            max-width: 900px;
            margin: auto;
            border-collapse: collapse;
            background: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #b3e5fc;
        }
        .action-link {
            margin: 0 5px;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            color: white;
        }
        .edit-link {
            background-color: #0288d1;
        }
        .delete-link {
            background-color: #d32f2f;
        }
        .due-soon {
            color: #e65100;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <a class="back-btn" href="vet_dashboard.jsp">&larr; Go Back to Dashboard</a>

    <h2>Track Cattle Vaccinations</h2>

    <!-- Form to Add Vaccine -->
    <form method="post">
        <label>Cattle ID:</label>
        <input type="text" name="cattle_id" required>

        <label>Vaccine Name:</label>
        <input type="text" name="vaccine_name" required>

        <label>Due Date:</label>
        <input type="date" name="due_date" required>

        <button type="submit">Add Vaccine</button>
    </form>

    <!-- Display Vaccine Records -->
    <table>
        <tr>
            <th>ID</th>
            <th>Cattle ID</th>
            <th>Vaccine</th>
            <th>Due Date</th>
            <th>Reminder</th>
            <th>Actions</th>
        </tr>
        <%
            java.util.Date today = new java.util.Date();
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

            while (rs != null && rs.next()) {
                String dueDateStr = rs.getString("due_date");
                java.util.Date due = sdf.parse(dueDateStr);
                long daysLeft = (due.getTime() - today.getTime()) / (1000 * 60 * 60 * 24);
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("cattle_id") %></td>
            <td><%= rs.getString("vaccine_name") %></td>
            <td><%= dueDateStr %></td>
            <td>
                <% if (daysLeft <= 3 && daysLeft >= 0) { %>
                    <span class="due-soon">Due in <%= daysLeft %> day(s)</span>
                <% } else if (daysLeft < 0) { %>
                    <span style="color: red;">Overdue</span>
                <% } else { %>
                    -
                <% } %>
            </td>
            <td>
                <a class="action-link edit-link" href="edit_vaccine.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                <a class="action-link delete-link" href="vaccine_tracking.jsp?delete=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure you want to delete this entry?');">Delete</a>
            </td>
        </tr>
        <% } %>
    </table>

</body>
</html>
