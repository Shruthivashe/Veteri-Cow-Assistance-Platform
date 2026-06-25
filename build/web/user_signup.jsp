<%-- 
    Document   : user_signup
    Created on : 8 Aug 2025, 7:39:51 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>User Sign Up</title>
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(to right, #e0f7f1, #cde9ff);
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
      color: #2d5c86;
    }
    input {
      width: 100%;
      margin: 10px 0;
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #a3cde5;
    }
    input[type="submit"] {
      background: #2d5c86;
      color: white;
      border: none;
      cursor: pointer;
      font-weight: bold;
    }
    input[type="submit"]:hover {
      background: #244d73;
    }
  </style>
</head>
<body>
  <form action="user_signup_process.jsp" method="post">
    <h2>User Sign Up</h2>
    <input type="text" name="username" placeholder="Username" required />
    <input type="email" name="email" placeholder="Email" required />
    <input type="password" name="password" placeholder="Password" required />
    <input type="submit" value="Register as User" />
    <p style="text-align:center; margin-top:1rem;">
  Not a user? <a href="vet_signup.jsp" style="color: #2d5c86; font-weight: bold;">Sign Up as Vet</a>
</p>
<p style="text-align:center; margin-top:1rem;">
 <a href="index.html" style="color: #2d5c86; font-weight: bold;">Go Back </a>
</p>

  </form>
    
</body>
</html>
