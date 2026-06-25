<%-- 
    Document   : appointments_vet
    Created on : 8 Aug 2025, 6:55:22 pm
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
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointments | Veteri Cow Assist</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4fff6;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #2e7d32;
        }
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px 16px;
            border-bottom: 1px solid #e0e0e0;
            text-align: center;
        }
        th {
            background-color: #a5d6a7;
            color: #1b5e20;
        }
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
        }
        .accept {
            background-color: #4caf50;
        }
        .reject {
            background-color: #f44336;
        }
        .status {
            font-weight: bold;
            color: #555;
        }
    </style>
</head>
<body>
    <h1>Vet Appointments</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Cattle ID</th>
            <th>Owner</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        String sql = "SELECT * FROM appointments_vet ORDER BY date DESC";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            int id = rs.getInt("id");
            String cattle_id = rs.getString("cattle_id");
            String owner = rs.getString("owner_name");
            String date = rs.getString("date");
            String time = rs.getString("time");
            String status = rs.getString("status");
%>
        <tr>
            <td><%= id %></td>
            <td><%= cattle_id %></td>
            <td><%= owner %></td>
            <td><%= date %></td>
            <td><%= time %></td>
            <td class="status"><%= status %></td>
            <td>
                <form action="update_status.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="status" value="Accepted">
                    <button class="btn accept" type="submit">Accept</button>
                </form>
                <form action="update_status.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="status" value="Rejected">
                    <button class="btn reject" type="submit">Reject</button>
                </form>
            </td>
        </tr>
<%
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
    </table>
    <p style="text-align:center; margin-top:1rem;">
    <a href="vet_dashboard.jsp" style="color: #2d5c86; font-weight: bold;">Go Back </a>
    </p>
</body>
</html>


