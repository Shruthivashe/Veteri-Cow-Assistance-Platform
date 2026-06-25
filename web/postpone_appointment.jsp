<%-- 
    Document   : postpone_appointment
    Created on : 8 Aug 2025, 7:07:38 pm
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

    String appointmentId = request.getParameter("appointment_id");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newDate = request.getParameter("date");
        String newTime = request.getParameter("time") + " " + request.getParameter("ampm");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

            ps = conn.prepareStatement("UPDATE appointments_vet SET date = ?, time = ? WHERE id = ? AND owner_name = ?");
            ps.setString(1, newDate);
            ps.setString(2, newTime);
            ps.setInt(3, Integer.parseInt(appointmentId));
            ps.setString(4, username);
            int updated = ps.executeUpdate();

            if (updated > 0) {
                message = "Appointment postponed successfully!";
                response.sendRedirect("schedule_appointment.jsp");
            } else {
                message = "Failed to postpone appointment. Check if the appointment exists.";
            }

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Postpone Appointment</title>
    <style>
        body {
            background: #f3f9f8;
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .box {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 400px;
        }
        h2 {
            text-align: center;
            color: #2e7d32;
        }
        input, select, button {
            width: 100%;
            margin-top: 10px;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .btn {
            background: #2e7d32;
            color: white;
            font-weight: bold;
            border: none;
            margin-top: 20px;
            cursor: pointer;
        }
        .btn:hover {
            background: #27632a;
        }
        .back {
            text-align: center;
            margin-top: 10px;
        }
        .back a {
            color: #2e7d32;
            font-weight: bold;
            text-decoration: none;
        }
        .msg {
            text-align: center;
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="box">
        <h2>Postpone Appointment</h2>
        <% if (!message.isEmpty()) { %>
            <p class="msg"><%= message %></p>
        <% } %>
        <form method="post">
            <input type="hidden" name="appointment_id" value="<%= appointmentId %>" />
            <label for="date">New Date</label>
            <input type="date" name="date" required />
            
            <label for="time">New Time</label>
            <div style="display:flex; gap:10px;">
                <input type="time" name="time" required style="flex:1;">
                <select name="ampm" style="width: 80px;">
                    <option value="AM">AM</option>
                    <option value="PM">PM</option>
                </select>
            </div>
            <button class="btn" type="submit">Postpone</button>
        </form>
        <div class="back">
            <a href="appointments.jsp">← Back to Appointments</a>
        </div>
    </div>
</body>
</html>
