<%-- 
    Document   : vet_login1
    Created on : 8 Aug 2025, 7:47:19 pm
    Author     : User
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page session="true" %>
<%
    String msg = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
            ps = conn.prepareStatement("SELECT * FROM vets WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("user", username);
                response.sendRedirect("vet_dashboard.jsp");
                return;
            } else {
                msg = "Invalid credentials. Please try again.";
            }
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        } finally {
            if (conn != null) conn.close();
        }
    }

    String deleteMsg = request.getParameter("msg");
    if ("deleted".equals(deleteMsg)) {
        msg = "Account deleted successfully!";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vet Login - Veteri Cow Assist</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #bbdefb, #e3f2fd);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .login-box {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            width: 350px;
        }
        h2 {
            text-align: center;
            color: #1565c0;
            margin-bottom: 25px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        button {
            width: 100%;
            padding: 10px;
            margin-top: 20px;
            background-color: #1565c0;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0d47a1;
        }
        .message {
            margin-top: 15px;
            text-align: center;
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #1565c0;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Vet Login</h2>
        <form method="post">
            <label>Username:</label>
            <input type="text" name="username" required>

            <label>Password:</label>
            <input type="password" name="password" required>

            <button type="submit">Login</button>
        </form>

        <% if (!msg.equals("")) { %>
            <div class="message <%= msg.contains("Invalid") || msg.contains("Error") ? "error" : "" %>">
                <%= msg %>
            </div>
        <% } %>

        <a href="index.html" class="back-link">← Back to Home</a>
    </div>
</body>
</html>
