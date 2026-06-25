<%-- 
    Document   : user_login1
    Created on : 8 Aug 2025, 7:38:21 pm
    Author     : User
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
    <title>User Login - Veteri Cow Assist</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #bbdefb, #e3f2fd);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-box {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: #1565c0;
            margin-bottom: 30px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #0d47a1;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #1976d2;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0d47a1;
        }

        .message {
            text-align: center;
            color: green;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .go-back {
            display: block;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
            background-color: #e3f2fd;
            color: #0d47a1;
            padding: 10px;
            border-radius: 8px;
            transition: background-color 0.3s;
        }

        .go-back:hover {
            background-color: #bbdefb;
        }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>User Login</h2>

        <% 
            String message = request.getParameter("message");
            if (message != null && !message.trim().isEmpty()) {
        %>
            <div class="message"><%= message %></div>
        <% } %>

        <form action="user_login_process.jsp" method="post">
            <label>Username</label>
            <input type="text" name="username" required />

            <label>Password</label>
            <input type="password" name="password" required />

            <button type="submit">Login</button>
        </form>

        <a class="go-back" href="index.html">← Go Back to Home</a>
    </div>

</body>
</html>