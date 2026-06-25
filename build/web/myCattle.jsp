<%-- 
    Document   : myCattle
    Created on : 8 Aug 2025, 7:02:36 pm
    Author     : User
--%>

<%@ page import="java.sql.*, java.util.*, java.io.*" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null, ps2 = null;
    ResultSet rs = null, rs2 = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Cattle - Veteri Cow Assist</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4fcf8;
            color: #222;
            margin: 0;
            padding: 0;
        }

        header {
            background: #2e7d32;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .title {
            font-size: 1.8rem;
            font-weight: bold;
        }

        .actions {
            display: flex;
            gap: 1rem;
        }

        .actions button {
            padding: 0.5rem 1rem;
            border: none;
            background: white;
            color: #2e7d32;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
        }

        .actions button:hover {
            background: #d0f2d4;
        }

        .container {
            padding: 2rem;
        }

        .search-bar {
            margin-bottom: 1rem;
        }

        .search-bar input {
            padding: 0.5rem;
            width: 250px;
            border: 1px solid #aaa;
            border-radius: 5px;
        }

        .search-bar button {
            padding: 0.5rem 1rem;
            margin-left: 0.5rem;
            border: none;
            background: #2e7d32;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        .search-bar button:hover {
            background: #256528;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            background: white;
            box-shadow: 0 0 8px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .export-container {
            text-align: right;
            margin-top: 1rem;
        }

        .export-btn {
            background: #2e7d32;
            color: white;
            padding: 0.5rem 1rem;
            margin-top: 0.5rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .export-btn:hover {
            background: #256528;
        }
    </style>
</head>
<body>

<header>
    <div class="title">🐄 My Cattle Records</div>
    <div class="actions">
        <button onclick="window.location.href='registerCattle.jsp'">➕ Add Cattle</button>
        <button onclick="window.location.href='user_dashboard.jsp'">🔙 Back</button>
    </div>
</header>

<div class="container">
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search by Cattle ID or Symptoms...">
        <button onclick="searchTable()">Search</button>
    </div>

    <table id="cattleTable">
        <tr>
            <th>Cattle ID</th>
            <th>Vet Username</th>
            <th>Symptoms</th>
            <th>Temperature</th>
            <th>Diagnosis</th>
            <th>Treatment</th>
            <th>Observed On</th>
            <th>Latest Vaccine</th>
            <th>Due Date</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/veteri", "root", "Root@123");

                ps = conn.prepareStatement("SELECT * FROM cattle_health WHERE cattle_id IN (SELECT cattle_id FROM cattle WHERE owner_username = ?) ORDER BY date_observed DESC");
                ps.setString(1, username);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String cattleId = rs.getString("cattle_id");
                    String vetUsername = rs.getString("vet_username");
                    String symptoms = rs.getString("symptoms");
                    String temperature = rs.getString("temperature");
                    String diagnosis = rs.getString("diagnosis");
                    String treatment = rs.getString("treatment");
                    String dateObserved = rs.getString("date_observed");

                    String vaccineName = "—";
                    String dueDate = "—";

                    ps2 = conn.prepareStatement("SELECT vaccine_name, due_date FROM vaccine_tracking WHERE cattle_id = ? ORDER BY due_date DESC LIMIT 1");
                    ps2.setString(1, cattleId);
                    rs2 = ps2.executeQuery();

                    if (rs2.next()) {
                        vaccineName = rs2.getString("vaccine_name");
                        dueDate = rs2.getString("due_date");
                    }
        %>
        <tr>
            <td><%= cattleId %></td>
            <td><%= vetUsername %></td>
            <td><%= symptoms %></td>
            <td><%= temperature %></td>
            <td><%= diagnosis %></td>
            <td><%= treatment %></td>
            <td><%= dateObserved %></td>
            <td><%= vaccineName %></td>
            <td><%= dueDate %></td>
        </tr>
        <%
                }
                if (rs2 != null) rs2.close();
                if (ps2 != null) ps2.close();
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='9' style='color:red;'>Error fetching records</td></tr>");
            }
        %>
    </table>

    <div class="export-container">
        <button class="export-btn" onclick="exportToPDF()">📄 Export as PDF</button>
    </div>
</div>

<!-- JS for search + export -->
<script>
    function searchTable() {
        const filter = document.getElementById("searchInput").value.toLowerCase();
        const rows = document.querySelectorAll("#cattleTable tr:not(:first-child)");
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(filter) ? "" : "none";
        });
    }

    function exportToPDF() {
        const table = document.getElementById("cattleTable").outerHTML;
        const blob = new Blob([table], { type: "application/pdf" });

        const a = document.createElement("a");
        a.href = URL.createObjectURL(blob);
        a.download = "cattle_records.pdf";
        a.click();
    }
</script>

</body>
</html>
