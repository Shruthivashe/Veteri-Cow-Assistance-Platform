<%-- 
    Document   : vet_login
    Created on : 8 Aug 2025, 7:46:41 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Vet Login</title>
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(to right, #d1f3e0, #e3f6f0);
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
      color: #217c5c;
    }
    input {
      width: 100%;
      margin: 10px 0;
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #9cd4b9;
    }
    input[type="submit"] {
      background: #217c5c;
      color: white;
      border: none;
      cursor: pointer;
      font-weight: bold;
    }
    input[type="submit"]:hover {
      background: #19644b;
    }
  </style>
</head>
<body>
  <form action="vet_login_process.jsp" method="post">
    <h2>Vet Login</h2>
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <input type="submit" value="Login as Vet" />
    <p style="text-align:center; margin-top:1rem;">
  Not a vet? <a href="user_login.jsp" style="color: #217c5c; font-weight: bold;">Login as User</a>
</p>
    <p style="text-align:center; margin-top:1rem;">
 <a href="index.html" style="color: #2d5c86; font-weight: bold;">Go Back </a>
</p>
  </form>
</body>
</html> 