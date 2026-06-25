<%-- 
    Document   : vet_dashboard
    Created on : 8 Aug 2025, 7:41:03 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page session="true" %>
<%
    String vetName = (String) session.getAttribute("user");
    if (vetName == null) {
        response.sendRedirect("vet_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Veteri Cow Assist | Vet Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0fff3;
            color: #222;
            transition: background 0.3s, color 0.3s;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background: #43a047;
            color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .header-title {
            font-size: 1.6rem;
            display: flex;
            flex-direction: column;
        }
        .header-title span {
            font-size: 1rem;
            font-weight: normal;
            opacity: 0.9;
        }
        .header-buttons {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .header-buttons button, .header-buttons a {
            background: none;
            border: none;
            font-size: 1.4rem;
            color: white;
            cursor: pointer;
            transition: color 0.3s;
        }
        .header-buttons button:hover {
            color: #d0ffd9;
        }

        .stats-grid {
            display: flex;
            justify-content: space-around;
            margin: 2rem auto 1rem auto;
            max-width: 1000px;
            gap: 1rem;
        }
        .stat-card {
            background: #c8e6c9;
            padding: 1.2rem;
            border-radius: 10px;
            flex: 1;
            text-align: center;
            font-size: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .card {
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
            text-align: center;
            text-decoration: none;
            color: #222;
            transition: all 0.2s ease-in-out;
        }
        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.12);
        }
        .card svg {
            width: 40px;
            height: 40px;
            margin-bottom: 0.5rem;
            fill: #4caf50;
        }

        /* Dark Mode */
        body.dark {
            background: #1c2c23;
            color: #eee;
        }
        body.dark .card {
            background: #2f4034;
            color: #eee;
        }
        body.dark .stat-card {
            background: #3d5744;
            color: #eee;
        }
        body.dark header {
            background: #2e7d32;
        }
    </style>
</head>
<body>
    <header>
        <div class="header-title">
            Veteri Cow Assist - Vet Dashboard
            <span>Welcome, <%= vetName %> 👨‍⚕️</span>
        </div>
        <div class="header-buttons">
            <button onclick="toggleDarkMode()" title="Toggle Dark Mode">🌙</button>
            <form action="logout.jsp" method="post" style="margin:0;">
                <button type="submit" title="Logout">⏻</button>
            </form>
        </div>
    </header>

    <!-- Stats Row -->
    <div class="stats-grid">
        <div class="stat-card">Appointments Today: 4</div>
        <div class="stat-card">Pending Prescriptions: 2</div>
        <div class="stat-card">Unread Messages: 5</div>
    </div>

    <!-- Main Cards -->
    <div class="grid">
        <a href="appointments_vet.jsp" class="card">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.1 0-1.99.9-1.99 2L3 21a2 2 0 002 2h14a2 2 0 002-2V5c0-1.1-.9-2-2-2zM5 21V8h14v13H5z"/></svg>
            <h3>Appointments</h3>
            <p>Manage your scheduled visits.</p>
        </a>
        <a href="prescriptions_vet.jsp" class="card">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M17.75 4A2.25 2.25 0 0120 6.25v11.5A2.25 2.25 0 0117.75 20H6.25A2.25 2.25 0 014 17.75V6.25A2.25 2.25 0 016.25 4h11.5zM8 8v8h8V8H8z"/></svg>
            <h3>Prescriptions</h3>
            <p>Create and view cattle treatments.</p>
        </a>
        <a href="patients_vet.jsp" class="card">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 12a5 5 0 100-10 5 5 0 000 10zm7 9v-1a7 7 0 00-14 0v1h14z"/></svg>
            <h3>My Patients</h3>
            <p>Manage cattle under your care.</p>
        </a>
        <a href="vaccine_tracking.jsp" class="card">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M17.71 6.29a1 1 0 00-1.42 0l-1.34 1.34-1.41-1.41 1.34-1.34a1 1 0 00-1.42-1.42l-1.34 1.34-1.41-1.41L15.3 2.3a1 1 0 111.42 1.42L17.71 6.3zM5 8v11a2 2 0 002 2h10a2 2 0 002-2V9.41l-6.59 6.6a1 1 0 01-1.42 0L5 8z"/></svg>
            <h3>Vaccine Tracker</h3>
            <p>Track cattle vaccination records.</p>
        </a>
        <a href="health_monitor.jsp" class="card">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14l4-4h12c1.1 0 2-.9 2-2V5a2 2 0 00-2-2z"/></svg>
            <h3>Health Monitoring</h3>
            <p>Check cattle health trends.</p>
        </a>
        <a href="vet_profile.jsp" class="card">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 12a5 5 0 100-10 5 5 0 000 10zm0 2c-3 0-5 2-5 4v1h10v-1c0-2-2-4-5-4z"/></svg>
            <h3>My Profile</h3>
            <p>Update info & availability.</p>
        </a>
    </div>

    <script>
        if (localStorage.getItem("darkMode") === "true") {
            document.body.classList.add("dark");
        }
        function toggleDarkMode() {
            document.body.classList.toggle("dark");
            localStorage.setItem("darkMode", document.body.classList.contains("dark"));
        }
    </script>
</body>
</html>
