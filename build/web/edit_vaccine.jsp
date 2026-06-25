<%-- 
    Document   : edit_vaccine
    Created on : 8 Aug 2025, 7:00:46 pm
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

    String idParam = request.getParameter("id");
    int vaccineId = idParam != null ? Integer.parseInt(idParam) : -1;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String cattleId = "", vaccineName = "", dueDate = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        // Handle update
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String updatedCattleId = request.getParameter("cattle_id");
            String updatedVaccineName = request.getParameter("vaccine_name");
            String updatedDueDate = request.getParameter("due_date");

            ps = conn.prepareStatement("UPDATE vaccine_tracking SET cattle_id=?, vaccine_name=?, due_date=? WHERE id=? AND vet_username=?");
            ps.setString(1, updatedCattleId);
            ps.setString(2, updatedVaccineName);
            ps.setDate(3, Date.valueOf(updatedDueDate));
            ps.setInt(4, vaccineId);
            ps.setString(5, vet);
            ps.executeUpdate();

            response.sendRedirect("vaccine_tracking.jsp");
            return;
        }

        // Load vaccine data
        ps = conn.prepareStatement("SELECT * FROM vaccine_tracking WHERE id=? AND vet_username=?");
        ps.setInt(1, vaccineId);
        ps.setString(2, vet);
        rs = ps.executeQuery();
        if (rs.next()) {
            cattleId = rs.getString("cattle_id");
            vaccineName = rs.getString("vaccine_name");
            dueDate = rs.getString("due_date");
        } else {
            out.println("<p style='color:red;'>No record found or access denied.</p>");
            return;
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Vaccine</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f3f9ff;
            padding: 20px;
            color: #333;
        }
        h2 {
            text-align: center;
            color: #1976d2;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            background: #1565c0;
            color: white;
            padding: 8px 14px;
            border-radius: 5px;
            text-decoration: none;
        }
        form {
            max-width: 600px;
            margin: auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 15px;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background: #0288d1;
            color: white;
            border: none;
            padding: 10px 16px;
            margin-top: 20px;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <a class="back-btn" href="vaccine_tracking.jsp">&larr; Go Back</a>

    <h2>Edit Vaccine Entry</h2>

    <form method="post">
        <label>Cattle ID:</label>
        <input type="text" name="cattle_id" value="<%= cattleId %>" required>

        <label>Vaccine Name:</label>
        <input type="text" name="vaccine_name" value="<%= vaccineName %>" required>

        <label>Due Date:</label>
        <input type="date" name="due_date" value="<%= dueDate %>" required>

        <button type="submit">Update Vaccine</button>
    </form>

</body>
</html>
