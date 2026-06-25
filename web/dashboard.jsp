<%-- 
    Document   : dashboard
    Created on : 8 Aug 2025, 6:57:38 pm
    Author     : User
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Veteri Cow Assist - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Rubik:wght@400;600&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a2e0e6e6f4.js" crossorigin="anonymous"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Rubik', sans-serif;
            background: linear-gradient(135deg, #f1fce5, #d0f2f2);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .card {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 700px;
            width: 90%;
            animation: fadeInUp 1.2s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card h1 {
            font-size: 36px;
            color: #007f5f;
            margin-bottom: 20px;
            animation: pulse 2.5s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                color: #007f5f;
            }
            50% {
                transform: scale(1.05);
                color: #35a67c;
            }
        }

        .buttons {
            margin-top: 30px;
        }

        .btn {
            padding: 12px 28px;
            margin: 10px;
            font-size: 16px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .signup {
            background-color: #4caf50;
            color: white;
        }

        .login {
            background-color: #0077b6;
            color: white;
        }

        .icon {
            font-size: 50px;
            color: #69c28c;
            margin-bottom: 20px;
            animation: bounce 1.5s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
    </style>
</head>
<body>

    <div class="card">
        <div class="icon">
            <i class="fas fa-cow"></i>
        </div>
        <h1>Need to Sign Up to Continue Further</h1>
        <p style="font-size: 18px; color: #444;">Join Veteri Cow Assist for seamless cattle health monitoring, prescriptions, and more.</p>
        <div class="buttons">
            <form action="user_signup.jsp" style="display:inline;">
                <button class="btn signup">Sign Up</button>
            </form>
            <form action="user_login.jsp" style="display:inline;">
                <button class="btn login">Login</button>
            </form>
        </div>
    </div>

</body>
</html>


