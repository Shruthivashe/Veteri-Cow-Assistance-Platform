<%-- 
    Document   : user_login
    Created on : 8 Aug 2025, 7:35:59 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>User Login</title>
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(to right, #d6f0ff, #e5f8f0);
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    form {
      background: #ffffff;
      padding: 2rem;
      border-radius: 16px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
      width: 350px;
    }
    h2 {
      text-align: center;
      color: #2a7e78;
    }
    input {
      width: 100%;
      margin: 10px 0;
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #a6ddd3;
    }
    input[type="submit"] {
      background: #2a7e78;
      color: white;
      border: none;
      cursor: pointer;
      font-weight: bold;
    }
    input[type="submit"]:hover {
      background: #206560;
    }
  </style>
</head>
<body>
  <form action="user_login_process.jsp" method="post">
    <h2>User Login</h2>
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <input type="submit" value="Login as User" />
    <p style="text-align:center; margin-top:1rem;">
        Not a user? <a href="vet_login.jsp" style="color: #2a7e78; font-weight: bold;">Login as Vet</a>
    </p>
        <p style="text-align:center; margin-top:1rem;">
 <a href="index.html" style="color: #2d5c86; font-weight: bold;">Go Back </a>
</p>

  </form>
</body>
</html>