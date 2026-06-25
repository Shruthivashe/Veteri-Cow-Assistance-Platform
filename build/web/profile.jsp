<%-- 
    Document   : profile
    Created on : 8 Aug 2025, 7:10:10 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String email = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
        ps = conn.prepareStatement("SELECT email FROM users WHERE username=?");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next()) {
            email = rs.getString("email");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #e3f2fd;
            padding: 30px;
        }
        .container {
            background: #ffffff;
            max-width: 700px;
            margin: auto;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #1565c0;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
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
            background-color: #1976d2;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            margin-top: 20px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0d47a1;
        }
        .delete-btn {
            background-color: #e53935;
            margin-left: 10px;
        }
        .delete-btn:hover {
            background-color: #b71c1c;
        }
        .back-btn {
            display: inline-block;
            text-decoration: none;
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #bbdefb;
            color: #0d47a1;
            border-radius: 6px;
        }
        .message {
            text-align: center;
            color: green;
            margin-top: 10px;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .section-title {
            color: #0d47a1;
            margin-top: 30px;
        }
    </style>
        
</head>
<body>
    <div class="container">
        <h2>Your Profile</h2>

        <div class="username-box">
            Username: <%= username %>
        </div>

        <form method="post" action="update_email.jsp">
            <label>Current Email</label>
            <input type="email" name="email" value="<%= email %>" required />
            <input type="hidden" name="username" value="<%= username %>" />
            <button type="submit" class="btn update-btn">Update Email</button>
        </form>

        <form method="post" action="change_password.jsp">
            <label>New Password</label>
            <input type="password" name="new_password" required />
            <input type="hidden" name="username" value="<%= username %>" />
            <button type="submit" class="btn password-btn">Change Password</button>
        </form>

       <form method="post" action="delete_account_simulate.jsp" 
      onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone!');">
        <input type="hidden" name="action" value="delete_account">
        <button type="submit" class="delete-btn">Delete My Account</button>
    </form>


       

        <a href="user_dashboard.jsp" class="back-btn">← Go Back to Dashboard</a>
    </div>
</body>
</html>
