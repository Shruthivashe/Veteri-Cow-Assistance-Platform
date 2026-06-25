<%-- 
    Document   : edit_prescription
    Created on : 8 Aug 2025, 7:00:14 pm
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

    int id = Integer.parseInt(request.getParameter("id"));
    String message = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String medicine = "", dosage = "", instructions = "", cattleId = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        // Handle update
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            medicine = request.getParameter("medicine");
            dosage = request.getParameter("dosage");
            instructions = request.getParameter("instructions");

            ps = conn.prepareStatement("UPDATE prescriptions SET medicine_name=?, dosage=?, instructions=? WHERE id=? AND vet_username=?");
            ps.setString(1, medicine);
            ps.setString(2, dosage);
            ps.setString(3, instructions);
            ps.setInt(4, id);
            ps.setString(5, vet);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                response.sendRedirect("prescriptions_vet.jsp");
                return;
            } else {
                message = "Update failed or unauthorized access.";
            }
        }

        // Load existing prescription
        ps = conn.prepareStatement("SELECT * FROM prescriptions WHERE id=? AND vet_username=?");
        ps.setInt(1, id);
        ps.setString(2, vet);
        rs = ps.executeQuery();
        if (rs.next()) {
            medicine = rs.getString("medicine_name");
            dosage = rs.getString("dosage");
            instructions = rs.getString("instructions");
            cattleId = rs.getString("cattle_id");
        } else {
            message = "Prescription not found or unauthorized.";
        }

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Prescription</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f1fff5;
            color: #333;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #2e7d32;
        }
        .container {
            background: #fff;
            max-width: 600px;
            margin: auto;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 16px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        label {
            font-weight: bold;
            color: #333;
        }
        button {
            background-color: #4caf50;
            color: white;
            padding: 12px 18px;
            font-size: 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>

<h2>Edit Prescription</h2>

<div class="container">
    <% if (!message.isEmpty()) { %>
        <p class="error"><%= message %></p>
    <% } %>
    <form method="post">
        <label>Cattle ID (readonly):</label>
        <input type="text" name="cattle_id" value="<%= cattleId %>" readonly>

        <label>Medicine Name:</label>
        <input type="text" name="medicine" value="<%= medicine %>" required>

        <label>Dosage:</label>
        <input type="text" name="dosage" value="<%= dosage %>" required>

        <label>Instructions:</label>
        <textarea name="instructions" rows="4"><%= instructions %></textarea>

        <button type="submit">Update Prescription</button>
    </form>
</div>

</body>
</html>

<% if (conn != null) conn.close(); %>
