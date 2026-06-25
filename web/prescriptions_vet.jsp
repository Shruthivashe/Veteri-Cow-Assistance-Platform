<%-- 
    Document   : prescriptions_vet
    Created on : 8 Aug 2025, 7:08:23 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String vet = (String) session.getAttribute("user");
    if (vet == null) {
        response.sendRedirect("vet_login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps;
    ResultSet rs;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        // Handle deletion
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            ps = conn.prepareStatement("DELETE FROM prescriptions WHERE id=?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.executeUpdate();
        }

        // Handle addition
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String cattleId = request.getParameter("cattle_id");
            String medicine = request.getParameter("medicine");
            String dosage = request.getParameter("dosage");
            String instructions = request.getParameter("instructions");

            if (cattleId != null && medicine != null) {
                ps = conn.prepareStatement("INSERT INTO prescriptions (vet_username, cattle_id, medicine_name, dosage, instructions) VALUES (?, ?, ?, ?, ?)");
                ps.setString(1, vet);
                ps.setString(2, cattleId);
                ps.setString(3, medicine);
                ps.setString(4, dosage);
                ps.setString(5, instructions);
                ps.executeUpdate();
            }
        }

        ps = conn.prepareStatement("SELECT * FROM prescriptions WHERE vet_username = ? ORDER BY date_prescribed DESC");
        ps.setString(1, vet);
        rs = ps.executeQuery();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        rs = null;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Prescriptions | Vet</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #e8f5e9;
            padding: 20px;
            color: #333;
        }
        .top-back-btn {
            display: inline-block;
            background-color: #66bb6a;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: background 0.3s ease;
        }

        .top-back-btn:hover {
            background-color: #388e3c;
        }
        h2 {
            text-align: center;
            color: #2e7d32;
        }
        form {
            background: #ffffff;
            padding: 20px;
            max-width: 600px;
            margin: auto;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        form input, textarea {
            width: 100%;
            padding: 8px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        form button {
            background: #4caf50;
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 1rem;
            border-radius: 6px;
            cursor: pointer;
        }
        .prescription-list {
            max-width: 800px;
            margin: 40px auto;
            border-collapse: collapse;
            width: 100%;
        }
        .prescription-list th, .prescription-list td {
            border: 1px solid #ccc;
            padding: 10px;
        }
        .prescription-list th {
            background: #a5d6a7;
        }
        .action-btn {
            padding: 4px 10px;
            margin-right: 4px;
            text-decoration: none;
            border-radius: 4px;
            color: white;
        }
        .edit-btn {
            background: #42a5f5;
        }
        .delete-btn {
            background: #ef5350;
        }
    </style>
</head>
<body>
    <h2>Prescriptions for Cattle</h2>

    <!-- Form to add prescription -->
    <form method="post">
        <label>Cattle ID:</label>
        <input type="text" name="cattle_id" required>

        <label>Medicine Name:</label>
        <input type="text" name="medicine" required>

        <label>Dosage:</label>
        <input type="text" name="dosage" required>

        <label>Instructions:</label>
        <textarea name="instructions" rows="3"></textarea>

        <button type="submit">Add Prescription</button>
    </form>

    <!-- List of prescriptions -->
    <table class="prescription-list">
        <tr>
            <th>Date</th>
            <th>Cattle ID</th>
            <th>Medicine</th>
            <th>Dosage</th>
            <th>Instructions</th>
            <th>Actions</th>
        </tr>
        <%
            if (rs != null) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getDate("date_prescribed") %></td>
            <td><%= rs.getString("cattle_id") %></td>
            <td><%= rs.getString("medicine_name") %></td>
            <td><%= rs.getString("dosage") %></td>
            <td><%= rs.getString("instructions") %></td>
            <td>
                <a class="action-btn edit-btn" href="edit_prescription.jsp?id=<%=rs.getInt("id")%>">Edit</a>
                <a class="action-btn delete-btn" href="prescriptions_vet.jsp?delete=<%=rs.getInt("id")%>" onclick="return confirm('Delete this prescription?');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
     <div style="text-align: left; margin-bottom: 20px;">
        <a href="vet_dashboard.jsp" class="top-back-btn">← Go Back</a>
    </div>
</body>
</html>

<% if (conn != null) conn.close(); %>
