<%-- 
    Document   : health_monitor
    Created on : 8 Aug 2025, 7:01:31 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*, java.time.*" %>
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

        // Delete health record
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            ps = conn.prepareStatement("DELETE FROM cattle_health WHERE id = ?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.executeUpdate();
        }

        // Insert new health record
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String cattleId = request.getParameter("cattle_id");
            String symptoms = request.getParameter("symptoms");
            String temperature = request.getParameter("temperature");
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String dateObserved = request.getParameter("date_observed");

            if (cattleId != null && !cattleId.trim().isEmpty()) {
                ps = conn.prepareStatement("INSERT INTO cattle_health (vet_username, cattle_id, symptoms, temperature, diagnosis, treatment, date_observed) VALUES (?, ?, ?, ?, ?, ?, ?)");
                ps.setString(1, vet);
                ps.setString(2, cattleId);
                ps.setString(3, symptoms);
                ps.setString(4, temperature);
                ps.setString(5, diagnosis);
                ps.setString(6, treatment);
                ps.setDate(7, Date.valueOf(dateObserved));
                ps.executeUpdate();
            }
        }

        // Fetch records
        ps = conn.prepareStatement("SELECT * FROM cattle_health WHERE vet_username = ? ORDER BY date_observed DESC");
        ps.setString(1, vet);
        rs = ps.executeQuery();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cattle Health Monitor</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9fbe7;
            color: #333;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #33691e;
        }
        .btn-back {
            background-color: #689f38;
            color: white;
            padding: 10px 16px;
            text-decoration: none;
            border-radius: 6px;
            margin-bottom: 20px;
            display: inline-block;
        }
        form {
            max-width: 700px;
            margin: 0 auto 30px auto;
            padding: 20px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        label {
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            margin: 8px 0 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background: #43a047;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background: #aed581;
        }
        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            margin-right: 5px;
        }
        .edit-btn { background-color: #0288d1; }
        .delete-btn { background-color: #e53935; }
        .view-btn { background-color: #7e57c2; }
    </style>
</head>
<body>

<a class="btn-back" href="vet_dashboard.jsp">&larr; Go Back</a>
<h2>Cattle Health Monitor</h2>

<form method="post">
    <label>Cattle ID:</label>
    <input type="text" name="cattle_id" required>

    <label>Date Observed:</label>
    <input type="date" name="date_observed" required>

    <label>Symptoms:</label>
    <textarea name="symptoms" required></textarea>

    <label>Temperature (°C):</label>
    <input type="text" name="temperature">

    <label>Diagnosis:</label>
    <textarea name="diagnosis"></textarea>

    <label>Treatment:</label>
    <textarea name="treatment"></textarea>

    <button type="submit">Add Health Record</button>
</form>

<table>
    <tr>
        <th>ID</th>
        <th>Cattle ID</th>
        <th>Date Observed</th>
        <th>Symptoms</th>
        <th>Actions</th>
    </tr>
<%
    while (rs != null && rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("cattle_id") %></td>
        <td><%= rs.getDate("date_observed") %></td>
        <td><%= rs.getString("symptoms") %></td>
        <td>
            <a class="action-btn view-btn" href="view_health.jsp?id=<%= rs.getInt("id") %>">View</a>
            <a class="action-btn edit-btn" href="edit_health.jsp?id=<%= rs.getInt("id") %>">Edit</a>
            <a class="action-btn delete-btn" href="health_monitor.jsp?delete=<%= rs.getInt("id") %>" onclick="return confirm('Delete this record?');">Delete</a>
        </td>
    </tr>
<%
    }
    if (conn != null) conn.close();
%>
</table>

</body>
</html>
