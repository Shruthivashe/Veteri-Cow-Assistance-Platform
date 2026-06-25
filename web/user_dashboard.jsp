<%-- 
    Document   : user_dashboard
    Created on : 8 Aug 2025, 7:26:52 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    String fullName = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/veteri", "root", "Root@123");
        PreparedStatement ps = conn.prepareStatement("SELECT full_name FROM users WHERE username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            fullName = rs.getString("full_name");
        } else {
            fullName = username;
        }
        conn.close();
    } catch (Exception e) {
        fullName = username;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Veteri Cow Assist | User Dashboard</title>
    <style>
        :root {
            --primary: #2e7d32;
            --background: #f2fef3;
            --text: #222;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: var(--background);
            color: var(--text);
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(8px);
            border-bottom: 2px solid #c0e8d5;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border-radius: 0 0 14px 14px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .left-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .logo {
            width: 36px;
            height: 36px;
        }

        .brand-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary);
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-label {
            font-size: 1rem;
            padding: 0.25rem 0.6rem;
            background: #e1f8ec;
            border-radius: 20px;
            color: #2e7d32;
            font-weight: 500;
        }

        .actions button {
            background: none;
            border: none;
            font-size: 1.4rem;
            cursor: pointer;
            color: var(--primary);
            transition: transform 0.2s ease;
        }

        .actions button:hover {
            transform: scale(1.2);
        }

        .welcome {
            text-align: center;
            margin: 2rem auto;
            font-size: 1.6rem;
            font-weight: 600;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 1.5rem;
            width: 90%;
            max-width: 1100px;
            margin: 2rem auto;
        }

        .card {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 6px 14px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            color: var(--text);
        }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }

        .icon-bg {
            width: 60px;
            height: 60px;
            margin: 0 auto 12px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card h3 {
            margin: 0 0 0.4rem;
        }

        .card p {
            margin: 0;
            font-size: 0.9rem;
        }

        body.dark {
            --background: #1e2a23;
            --text: #f0f0f0;
        }

        body.dark .card {
            background: #2c3e33;
        }

        body.dark .brand-title {
            color: #a5d6a7;
        }

        body.dark .user-label {
            background: #2e7d32;
            color: white;
        }
    </style>
</head>
<body>

<header>
    <div class="left-brand">
        <img src="logo.png" class="logo" alt="Logo">
        <span class="brand-title">Veteri Cow Assist</span>
    </div>
    <div class="actions">
        <span class="user-label">👤 <%= fullName %></span>
        <button onclick="toggleDarkMode()" title="Toggle Theme">🌙</button>
        <form action="logout.jsp" method="post" style="margin:0;">
            <button title="Logout">⏻</button>
        </form>
    </div>
</header>

<div class="welcome">Welcome, <%= fullName %>!</div>

<div class="grid">
    <a href="myCattle.jsp" class="card">
        <div class="icon-bg" style="background:#e8f5e9;">
            <svg viewBox="0 0 64 64" width="36" height="36" fill="#4CAF50">
                <path d="M24 10c-5 0-9 4-9 9v6H9c-1 0-2 .9-2 2v10c0 2 2 4 4 4h1c0 2 1 4 3 5v4h4v-4h12v4h4v-4c2-1 3-3 3-5h1c2 0 4-2 4-4V27c0-1.1-.9-2-2-2h-6v-6c0-5-4-9-9-9h-4zM20 19c0-2 2-4 4-4h4c2 0 4 2 4 4v5H20v-5z"/>
                <circle cx="24" cy="24" r="2" fill="#2e7d32"/>
            </svg>
        </div>
        <h3>My Cattle</h3>
        <p>Manage and monitor your cattle records.</p>
    </a>

    <a href="registerCattle.jsp" class="card">
        <div class="icon-bg" style="background:#e0f2f1;">
            <svg fill="#2e7d32" viewBox="0 0 24 24" width="36" height="36"><path d="M13 11h8v2h-8v8h-2v-8H3v-2h8V3h2z"/></svg>
        </div>
        <h3>Register Cattle</h3>
        <p>Add new cattle to your herd.</p>
    </a>

    <a href="appointments.jsp" class="card">
        <div class="icon-bg" style="background:#e0f7fa;">
            <svg fill="#00897b" viewBox="0 0 24 24" width="36" height="36"><path d="M19 3h-1V1h-2v2H8V1H6v2H5a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2V5a2 2 0 00-2-2zm0 16H5V8h14v11z"/></svg>
        </div>
        <h3>Appointments</h3>
        <p>View and schedule bookings.</p>
    </a>

    <a href="prescriptions.jsp" class="card">
        <div class="icon-bg" style="background:#f3e5f5;">
            <svg fill="#6a1b9a" viewBox="0 0 24 24" width="36" height="36"><path d="M3 3h18v2H3V3zm0 4h18v2H3V7zm0 4h18v2H3v-2zm0 4h10v2H3v-2zm0 4h10v2H3v-2z"/></svg>
        </div>
        <h3>Prescriptions</h3>
        <p>Review treatment history.</p>
    </a>

    <a href="shop.jsp" class="card">
        <div class="icon-bg" style="background:#fff3e0;">
            <svg viewBox="0 0 24 24" width="36" height="36" fill="#EF6C00">
                <path d="M16 6V4a4 4 0 0 0-8 0v2H4v16h16V6h-4zM10 4a2 2 0 0 1 4 0v2h-4V4zm2 6a4 4 0 1 1-4 4 4.005 4.005 0 0 1 4-4zm1 2v2h2v2h-2v2h-2v-2H9v-2h2v-2h2z"/>
            </svg>
        </div>
        <h3>Shop</h3>
        <p>Buy medicine and supplies.</p>
    </a>

    <a href="profile.jsp" class="card">
        <div class="icon-bg" style="background:#e3f2fd;">
            <svg fill="#1565c0" viewBox="0 0 24 24" width="36" height="36"><path d="M12 12c2.67 0 8 1.34 8 4v4H4v-4c0-2.66 5.33-4 8-4zm0-2a4 4 0 100-8 4 4 0 000 8z"/></svg>
        </div>
        <h3>My Profile</h3>
        <p>Update personal information.</p>
    </a>

    <a href="payments.jsp" class="card">
        <div class="icon-bg" style="background:#ffebee;">
            <svg fill="#c62828" viewBox="0 0 24 24" width="36" height="36"><path d="M21 7H3V5h18v2zm0 2H3v10h18V9zm-2 4H5v-2h14v2z"/></svg>
        </div>
        <h3>Payments</h3>
        <p>Review and manage transactions.</p>
    </a>

    <a href="notifications.jsp" class="card">
        <div class="icon-bg" style="background:#fffde7;">
            <svg fill="#f9a825" viewBox="0 0 24 24" width="36" height="36"><path d="M12 22a2 2 0 002-2H10a2 2 0 002 2zm6-6V9a6 6 0 00-12 0v7l-2 2v1h16v-1l-2-2z"/></svg>
        </div>
        <h3>Notifications</h3>
        <p>Check updates and reminders.</p>
    </a>
</div>

<script>
    function toggleDarkMode() {
        document.body.classList.toggle('dark');
    }
</script>

</body>
</html>
