<%-- 
    Document   : vet_profile
    Created on : 8 Aug 2025, 7:48:04 pm
    Author     : User
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page session="true" %>
<%
    String vet = (String) session.getAttribute("user");
    if (vet == null) {
        response.sendRedirect("vet_login1.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String email = "", licenseNo = "", specialization = "";
    String msg = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");

            if ("update_profile".equals(action)) {
                email = request.getParameter("email");
                licenseNo = request.getParameter("license_no");
                specialization = request.getParameter("specialization");

                ps = conn.prepareStatement("UPDATE vets SET email=?, license_no=?, specialization=? WHERE username=?");
                ps.setString(1, email);
                ps.setString(2, licenseNo);
                ps.setString(3, specialization);
                ps.setString(4, vet);
                ps.executeUpdate();
                msg = "Profile updated successfully!";

            } else if ("update_password".equals(action)) {
                String oldPass = request.getParameter("old_password");
                String newPass = request.getParameter("new_password");

                ps = conn.prepareStatement("SELECT password FROM vets WHERE username=?");
                ps.setString(1, vet);
                rs = ps.executeQuery();
                if (rs.next() && rs.getString("password").equals(oldPass)) {
                    ps = conn.prepareStatement("UPDATE vets SET password=? WHERE username=?");
                    ps.setString(1, newPass);
                    ps.setString(2, vet);
                    ps.executeUpdate();
                    msg = "Password updated successfully!";
                } else {
                    msg = "Incorrect old password!";
                }

            } else if ("delete_account".equals(action)) {
                // Simulate account deletion — do not delete from DB
                session.invalidate(); // End session
                response.sendRedirect("vet_login1.jsp?msg=deleted"); // Redirect with fake message
                return;
            }
        }

        ps = conn.prepareStatement("SELECT * FROM vets WHERE username=?");
        ps.setString(1, vet);
        rs = ps.executeQuery();
        if (rs.next()) {
            email = rs.getString("email");
            licenseNo = rs.getString("license_no");
            specialization = rs.getString("specialization");
        }

    } catch (Exception e) {
        msg = "Error: " + e.getMessage();
    } finally {
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vet Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #e3f2fd;
            padding: 30px;
        }
        .container {
            background: #ffffff;
            max-width: 700px;
            margin: auto;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #1565c0;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            background-color: #1976d2;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            margin-top: 20px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0d47a1;
        }
        .delete-btn {
            background-color: #e53935;
            margin-left: 10px;
        }
        .delete-btn:hover {
            background-color: #b71c1c;
        }
        .back-btn {
            display: inline-block;
            text-decoration: none;
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #bbdefb;
            color: #0d47a1;
            border-radius: 6px;
        }
        .message {
            text-align: center;
            color: green;
            margin-top: 10px;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .section-title {
            color: #0d47a1;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Vet Profile</h2>

        <% if (!msg.equals("")) { %>
            <div class="<%= msg.contains("Error") || msg.contains("Incorrect") ? "error" : "message" %>">
                <%= msg %>
            </div>
        <% } %>

        <!-- Profile Update Form -->
        <form method="post">
            <input type="hidden" name="action" value="update_profile">

            <label>Email:</label>
            <input type="email" name="email" value="<%= email %>" required>

            <label>License Number:</label>
            <input type="text" name="license_no" value="<%= licenseNo %>" required>

            <label>Specialization:</label>
            <input type="text" name="specialization" value="<%= specialization %>">

            <button type="submit">Update Profile</button>
        </form>

        <!-- Password Update Form -->
        <div class="section-title">Change Password</div>
        <form method="post">
            <input type="hidden" name="action" value="update_password">
            <label>Old Password:</label>
            <input type="password" name="old_password" required>

            <label>New Password:</label>
            <input type="password" name="new_password" required>

            <button type="submit">Change Password</button>
        </form>

        <!-- Simulated Delete Account -->
        <div class="section-title">Delete Account</div>
        <form method="post" onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone!');">
            <input type="hidden" name="action" value="delete_account">
            <button type="submit" class="delete-btn">Delete My Account</button>
        </form>

        <a class="back-btn" href="vet_dashboard.jsp">← Go Back to Dashboard</a>
    </div>
</body>
</html>
