<%-- 
    Document   : patients_vet
    Created on : 8 Aug 2025, 7:04:04 pm
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

    Connection conn = null;
    PreparedStatement ps;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        // Handle deletion
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            ps = conn.prepareStatement("DELETE FROM cattle_patients WHERE id = ?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.executeUpdate();
        }

        // Handle insertion
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String cattleId = request.getParameter("cattle_id");
            String breed = request.getParameter("breed");
            String ageStr = request.getParameter("age");
            String notes = request.getParameter("notes");

            Integer age = null;
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                age = Integer.parseInt(ageStr);
            }

            if (cattleId != null && !cattleId.trim().isEmpty()) {
                ps = conn.prepareStatement("INSERT INTO cattle_patients (vet_username, cattle_id, breed, age, notes) VALUES (?, ?, ?, ?, ?)");
                ps.setString(1, vet);
                ps.setString(2, cattleId);
                ps.setString(3, breed);
                if (age != null) ps.setInt(4, age); else ps.setNull(4, java.sql.Types.INTEGER);
                ps.setString(5, notes);
                ps.executeUpdate();
            }
        }

        // Fetch patients
        ps = conn.prepareStatement("SELECT * FROM cattle_patients WHERE vet_username = ? ORDER BY id DESC");
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
    <title>My Cattle Patients</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f1f8e9;
            color: #333;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #2e7d32;
        }
        .btn-back {
            display: inline-block;
            margin-bottom: 20px;
            background: #689f38;
            color: white;
            padding: 8px 14px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }
        form {
            max-width: 600px;
            margin: 0 auto 30px auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background: #43a047;
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
            background: #a5d6a7;
        }
        .delete-btn {
            background: #e53935;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 4px;
        }
    </style>
</head>
<body>

    <a class="btn-back" href="vet_dashboard.jsp">&larr; Go Back</a>

    <h2>Manage Your Cattle Patients</h2>

    <!-- Add Patient Form -->
    <form method="post">
        <label>Cattle ID:</label>
        <input type="text" name="cattle_id" required>

        <label>Breed:</label>
        <input type="text" name="breed" placeholder="e.g., Gir, Sahiwal, Jersey">

        <label>Age (optional):</label>
        <input type="number" name="age" min="0" placeholder="Years">

        <label>Notes:</label>
        <textarea name="notes" rows="3" placeholder="Any medical or behavioral notes"></textarea>

        <button type="submit">Add Patient</button>
    </form>

    <!-- Display Patients -->
    <table>
        <tr>
            <th>ID</th>
            <th>Cattle ID</th>
            <th>Breed</th>
            <th>Age</th>
            <th>Notes</th>
            <th>Action</th>
        </tr>
        <%
            if (rs != null) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("cattle_id") %></td>
            <td><%= rs.getString("breed") %></td>
            <td><%= rs.getObject("age") != null ? rs.getInt("age") : "-" %></td>
            <td><%= rs.getString("notes") %></td>
            <td>
                <a class="delete-btn" href="patients_vet.jsp?delete=<%= rs.getInt("id") %>" onclick="return confirm('Delete this patient?');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
            if (conn != null) conn.close();
        %>
    </table>

</body>
</html>
