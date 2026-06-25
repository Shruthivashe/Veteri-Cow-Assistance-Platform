<%-- 
    Document   : prescriptions
    Created on : 8 Aug 2025, 7:09:00 pm
    Author     : User
--%>

<%@ page import="java.sql.*" session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    String cattleFilter = request.getParameter("cattle_id");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prescriptions | Veteri Cow Assist</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #e0f2f1, #f1f8e9);
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #2e7d32;
            color: white;
            padding: 1.2rem;
            text-align: center;
            font-size: 2rem;
            font-weight: bold;
        }

        .container {
            max-width: 1000px;
            margin: 2rem auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 2rem;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            padding: 0.75rem;
            text-align: center;
            border: 1px solid #ccc;
        }

        th {
            background-color: #c5e1a5;
            color: #2e7d32;
        }

        td {
            background-color: #f9fbe7;
        }

        .footer-buttons {
            margin-top: 2rem;
            display: flex;
            justify-content: space-between;
        }

        .footer-buttons a {
            padding: 0.9rem 1.8rem;
            text-decoration: none;
            background: #2e7d32;
            color: white;
            border-radius: 8px;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .footer-buttons a:hover {
            background: #1b5e20;
        }

        .no-data {
            color: #999;
            font-size: 1.2rem;
            margin-top: 2rem;
        }

        .search-bar {
            margin-bottom: 1.5rem;
        }

        input[type="text"] {
            padding: 10px;
            width: 250px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }

        button {
            padding: 10px 18px;
            background-color: #2e7d32;
            color: white;
            border: none;
            border-radius: 8px;
            margin-left: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background-color: #1b5e20;
        }

        .top-back-btn {
            display: inline-block;
            background-color: #66bb6a;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            margin-top: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .top-back-btn:hover {
            background-color: #388e3c;
        }
    </style>
</head>
<body>
<header>Your Cattle's Prescriptions</header>

<div class="container">
    <form method="get" class="search-bar">
        <input type="text" name="cattle_id" placeholder="Enter Cattle ID" value="<%= cattleFilter != null ? cattleFilter : "" %>"/>
        <button type="submit">Search</button>
    </form>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        String query = "SELECT p.* FROM prescriptions p JOIN cattle c ON p.cattle_id = c.cattle_id WHERE c.user_username = ?";
        if (cattleFilter != null && !cattleFilter.trim().isEmpty()) {
            query += " AND p.cattle_id = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, cattleFilter.trim());
        } else {
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
        }

        rs = ps.executeQuery();
        boolean hasData = false;

        while (rs.next()) {
            if (!hasData) {
%>
    <table>
        <thead>
        <tr>
            <th>Cattle ID</th>
            <th>Medicine</th>
            <th>Dosage</th>
            <th>Instructions</th>
            <th>Date Prescribed</th>
        </tr>
        </thead>
        <tbody>
<%
            hasData = true;
            }
%>
        <tr>
            <td><%= rs.getString("cattle_id") %></td>
            <td><%= rs.getString("medicine_name") %></td>
            <td><%= rs.getString("dosage") %></td>
            <td><%= rs.getString("instructions") %></td>
            <td><%= rs.getDate("date_prescribed") %></td>
        </tr>
<%
        }

        if (hasData) {
%>
        </tbody>
    </table>
<%
        } else {
%>
    <div class="no-data">No prescriptions found<% if (cattleFilter != null && !cattleFilter.isEmpty()) { %> for Cattle ID: <%= cattleFilter %><% } %>.</div>
<%
        }
    } catch (Exception e) {
%>
    <div class="no-data" style="color:red;">Error: <%= e.getMessage() %></div>
<%
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

    <div class="footer-buttons">
        <a href="shop.jsp">🛒 Shop</a>
        <a href="payment.jsp">💳 Payment</a>
    </div>

    <div>
        <a href="user_dashboard.jsp" class="top-back-btn">← Go Back</a>
    </div>
</div>
</body>
</html>

