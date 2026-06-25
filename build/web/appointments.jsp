<%-- 
    Document   : appointments
    Created on : 8 Aug 2025, 6:56:20 pm
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

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        // Schedule appointment
        if ("POST".equalsIgnoreCase(request.getMethod()) && "schedule".equals(request.getParameter("action"))) {
            String cattleId = request.getParameter("cattle_id");
            String date = request.getParameter("date");
            String time = request.getParameter("time") + " " + request.getParameter("ampm");

            ps = conn.prepareStatement("INSERT INTO appointments_vet (cattle_id, owner_name, date, time, status) VALUES (?, ?, ?, ?, 'Pending')");
            ps.setString(1, cattleId);
            ps.setString(2, username);
            ps.setString(3, date);
            ps.setString(4, time);
            ps.executeUpdate();
            message = "Appointment scheduled successfully!";
        }

        // Delete appointment
        if ("POST".equalsIgnoreCase(request.getMethod()) && "delete".equals(request.getParameter("action"))) {
            String id = request.getParameter("appointment_id");
            ps = conn.prepareStatement("DELETE FROM appointments_vet WHERE id=? AND owner_name=?");
            ps.setInt(1, Integer.parseInt(id));
            ps.setString(2, username);
            ps.executeUpdate();
            message = "Appointment deleted successfully!";
        }

        ps = conn.prepareStatement("SELECT * FROM appointments_vet WHERE owner_name=? ORDER BY date ASC");
        ps.setString(1, username);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedule Appointment</title>
    <style>
        body {
            background: #f0fdf4;
            font-family: 'Segoe UI', sans-serif;
            padding: 30px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2e7d32;
            text-align: center;
        }
        input, select, button {
            padding: 10px;
            margin: 5px 0;
            width: 100%;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        table, th, td {
            border: 1px solid #c5e1a5;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        .btn {
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-postpone {
            background-color: #fbc02d;
            color: white;
        }
        .btn-delete {
            background-color: #e53935;
            color: white;
        }
        .btn-submit {
            background-color: #43a047;
            color: white;
            font-weight: bold;
        }
        .msg {
            color: green;
            text-align: center;
            font-weight: bold;
        }
        .back-link {
            display: block;
            margin-top: 15px;
            text-align: center;
            color: #2e7d32;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Schedule Appointment</h2>
        <% if (!message.isEmpty()) { %>
            <p class="msg"><%= message %></p>
        <% } %>
        <form method="post">
            <input type="hidden" name="action" value="schedule">
            <input type="text" name="cattle_id" placeholder="Cattle ID" required>
            <input type="date" name="date" required>
            <div style="display:flex; gap:10px;">
                <input type="time" name="time" required style="flex:1;">
                <select name="ampm" style="width: 80px;">
                    <option value="AM">AM</option>
                    <option value="PM">PM</option>
                </select>
            </div>
            <button type="submit" class="btn-submit">Schedule</button>
        </form>

        <h2 style="margin-top: 40px;">Your Appointments</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Cattle ID</th>
                <th>Date</th>
                <th>Time</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            <%
                while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("cattle_id") %></td>
                <td><%= rs.getDate("date") %></td>
                <td><%= rs.getString("time") %></td>
                <td><%= rs.getString("status") %></td>
                <td>
                    <form action="postpone_appointment.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="appointment_id" value="<%= rs.getInt("id") %>">
                        <button type="submit" class="btn btn-postpone">Postpone</button>
                    </form>
                    <form method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="appointment_id" value="<%= rs.getInt("id") %>">
                        <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <a href="user_dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

