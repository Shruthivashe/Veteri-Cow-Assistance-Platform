<%-- 
    Document   : vet_signup
    Created on : 8 Aug 2025, 7:50:47 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Vet Sign Up</title>
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: linear-gradient(to right, #e1f7e7, #c8e7d6);
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
      width: 380px;
    }
    h2 {
      text-align: center;
      color: #2f7d51;
    }
    input {
      width: 100%;
      margin: 10px 0;
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #9ed7b4;
    }
    input[type="submit"] {
      background: #2f7d51;
      color: white;
      border: none;
      cursor: pointer;
      font-weight: bold;
    }
    input[type="submit"]:hover {
      background: #236242;
    }
  </style>
</head>
<body>
  <form action="vet_signup_process.jsp" method="post">
    <h2>Vet Sign Up</h2>
    <input type="text" name="username" placeholder="Username" required />
    <input type="email" name="email" placeholder="Email" required />
    <input type="text" name="license_no" placeholder="License Number" required />
    <input type="text" name="specialization" placeholder="Specialization" />
    <input type="password" name="password" placeholder="Password" required />
    <input type="submit" value="Register as Vet" />
    <p style="text-align:center; margin-top:1rem;">
        Not a vet? <a href="user_signup.jsp" style="color: #2f7d51; font-weight: bold;">Sign Up as User</a>
    </p>
    <p style="text-align:center; margin-top:1rem;">
 <a href="index.html" style="color: #2d5c86; font-weight: bold;">Go Back </a>
</p>
  </form>
</body>
</html>
