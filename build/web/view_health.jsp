<%-- 
    Document   : view_health
    Created on : 8 Aug 2025, 7:51:20 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String vet = (String) session.getAttribute("user");
    if (vet == null) {
        response.sendRedirect("vet_login.jsp");
        return;
    }

    String id = request.getParameter("id");
    Connection conn = null;
    PreparedStatement ps;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
        ps = conn.prepareStatement("SELECT * FROM cattle_health WHERE id = ? AND vet_username = ?");
        ps.setInt(1, Integer.parseInt(id));
        ps.setString(2, vet);
        rs = ps.executeQuery();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Health Record</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f1f8e9;
            padding: 20px;
        }
        .container {
            max-width: 700px;
            margin: auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #33691e;
            text-align: center;
        }
        .label {
            font-weight: bold;
            color: #444;
        }
        .value {
            margin-bottom: 15px;
        }
        .btn-back {
            display: inline-block;
            margin-top: 20px;
            background: #689f38;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Health Record Details</h2>
    <%
        if (rs != null && rs.next()) {
    %>
        <p><span class="label">Cattle ID:</span> <%= rs.getString("cattle_id") %></p>
        <p><span class="label">Date Observed:</span> <%= rs.getDate("date_observed") %></p>
        <p><span class="label">Symptoms:</span> <%= rs.getString("symptoms") %></p>
        <p><span class="label">Temperature:</span> <%= rs.getString("temperature") %></p>
        <p><span class="label">Diagnosis:</span> <%= rs.getString("diagnosis") %></p>
        <p><span class="label">Treatment:</span> <%= rs.getString("treatment") %></p>
    <%
        } else {
    %>
        <p style="color:red;">No record found or unauthorized access.</p>
    <%
        }
        if (conn != null) conn.close();
    %>

    <a class="btn-back" href="health_monitor.jsp">&larr; Back to Monitor</a>
</div>

</body>
</html>

