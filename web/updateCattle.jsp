<%-- 
    Document   : updateCattle
    Created on : 8 Aug 2025, 7:26:19 pm
    Author     : User
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String cattleId = request.getParameter("id");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String breed = "", age = "", gender = "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Cattle</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #e8f5e9;
            padding: 2rem;
        }
        .container {
            max-width: 500px;
            margin: auto;
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2e7d32;
            text-align: center;
        }
        input, select {
            width: 100%;
            margin: 1rem 0;
            padding: 0.8rem;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            width: 100%;
            padding: 0.8rem;
            background-color: #388e3c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }
        .back-link {
            display: block;
            margin-top: 1.5rem;
            text-align: center;
            background: #33691e;
            color: white;
            text-decoration: none;
            padding: 0.7rem 1.2rem;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Update Cattle</h2>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newBreed = request.getParameter("breed");
            String newAge = request.getParameter("age");
            String newGender = request.getParameter("gender");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
                ps = conn.prepareStatement("UPDATE cattle SET breed=?, age=?, gender=? WHERE cattle_id=?");
                ps.setString(1, newBreed);
                ps.setString(2, newAge);
                ps.setString(3, newGender);
                ps.setString(4, cattleId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    out.println("<p style='color: green;'>Cattle updated successfully!</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception e) {}
            }
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
                ps = conn.prepareStatement("SELECT * FROM cattle WHERE cattle_id=?");
                ps.setString(1, cattleId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    breed = rs.getString("breed");
                    age = rs.getString("age");
                    gender = rs.getString("gender");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception e) {}
            }
    %>
    <form method="post">
        <input type="text" name="breed" placeholder="Breed" value="<%= breed %>" required />
        <input type="number" name="age" placeholder="Age" value="<%= age %>" required />
        <select name="gender" required>
            <option value="">Select Gender</option>
            <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
            <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
        </select>
        <button type="submit">Update</button>
    </form>
    <% } %>
    <a href="registerCattle.jsp" class="back-link">← Go Back</a>
</div>
</body>
</html>
