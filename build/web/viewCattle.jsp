<%-- 
    Document   : viewCattle
    Created on : 8 Aug 2025, 7:52:30 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    String cattleId = request.getParameter("id");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Cattle</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f9f4;
            padding: 2rem;
        }
        .card {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: auto;
        }
        h2 {
            color: #2e7d32;
            text-align: center;
        }
        p {
            font-size: 1.1rem;
            margin: 0.6rem 0;
        }
        .back-link {
            display: block;
            margin-top: 2rem;
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
    <div class="card">
        <h2>Cattle Details</h2>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
                ps = conn.prepareStatement("SELECT * FROM cattle WHERE cattle_id = ?");
                ps.setString(1, cattleId);
                rs = ps.executeQuery();

                if (rs.next()) {
        %>
        <p><strong>Cattle ID:</strong> <%= rs.getString("cattle_id") %></p>
        <p><strong>Breed:</strong> <%= rs.getString("breed") %></p>
        <p><strong>Age:</strong> <%= rs.getString("age") %> years</p>
        <p><strong>Gender:</strong> <%= rs.getString("gender") %></p>
        <%
                } else {
                    out.println("<p>No cattle found with ID: " + cattleId + "</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
        <a href="registerCattle.jsp" class="back-link">← Go Back</a>
    </div>
</body>
</html>