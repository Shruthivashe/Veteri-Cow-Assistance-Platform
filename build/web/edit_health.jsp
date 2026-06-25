<%-- 
    Document   : edit_health
    Created on : 8 Aug 2025, 6:59:41 pm
    Author     : User
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page session="true" %>
<%
    String vet = (String) session.getAttribute("user");
    if (vet == null) {
        response.sendRedirect("vet_login.jsp");
        return;
    }

    String id = request.getParameter("id");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String cattleId = "", symptoms = "", temperature = "", diagnosis = "", treatment = "", dateObserved = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            cattleId = request.getParameter("cattle_id");
            symptoms = request.getParameter("symptoms");
            temperature = request.getParameter("temperature");
            diagnosis = request.getParameter("diagnosis");
            treatment = request.getParameter("treatment");
            dateObserved = request.getParameter("date_observed");

            ps = conn.prepareStatement("UPDATE cattle_health SET cattle_id=?, symptoms=?, temperature=?, diagnosis=?, treatment=?, date_observed=? WHERE id=? AND vet_username=?");
            ps.setString(1, cattleId);
            ps.setString(2, symptoms);
            ps.setString(3, temperature);
            ps.setString(4, diagnosis);
            ps.setString(5, treatment);
            ps.setDate(6, java.sql.Date.valueOf(dateObserved));
            ps.setInt(7, Integer.parseInt(id));
            ps.setString(8, vet);
            ps.executeUpdate();

            response.sendRedirect("health_monitor.jsp?msg=updated");
            return;
        }

        ps = conn.prepareStatement("SELECT * FROM cattle_health WHERE id=? AND vet_username=?");
        ps.setInt(1, Integer.parseInt(id));
        ps.setString(2, vet);
        rs = ps.executeQuery();

        if (rs.next()) {
            cattleId = rs.getString("cattle_id");
            symptoms = rs.getString("symptoms");
            temperature = rs.getString("temperature");
            diagnosis = rs.getString("diagnosis");
            treatment = rs.getString("treatment");
            dateObserved = String.valueOf(rs.getDate("date_observed"));
        } else {
            out.println("<p style='color:red;'>No record found or access denied.</p>");
            return;
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Health Record</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #e3f2fd;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #1565c0;
        }
        form {
            background: #ffffff;
            max-width: 700px;
            margin: 30px auto;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background-color: #1976d2;
            color: white;
            padding: 10px 20px;
            margin-top: 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0d47a1;
        }
    </style>
</head>
<body>

    <h2>Edit Cattle Health Record</h2>

    <form method="post">
        <label>Cattle ID:</label>
        <input type="text" name="cattle_id" value="<%= cattleId %>" required>

        <label>Symptoms:</label>
        <textarea name="symptoms" rows="2"><%= symptoms %></textarea>

        <label>Temperature (°C):</label>
        <input type="text" name="temperature" value="<%= temperature %>">

        <label>Diagnosis:</label>
        <textarea name="diagnosis" rows="2"><%= diagnosis %></textarea>

        <label>Treatment:</label>
        <textarea name="treatment" rows="2"><%= treatment %></textarea>

        <label>Date Observed:</label>
        <input type="date" name="date_observed" value="<%= dateObserved %>" required>

        <button type="submit">Update Record</button>
    </form>

</body>
</html>

<% if (conn != null) conn.close(); %>
