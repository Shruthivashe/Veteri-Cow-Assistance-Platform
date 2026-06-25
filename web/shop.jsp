<%-- 
    Document   : shop
    Created on : 9 Aug 2025, 5:10:56 pm
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    String cattleId = request.getParameter("cattle_id");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medication Records | Veteri Cow Assist</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f3f6fd;
            color: #1a237e;
        }

        header {
            background-color: #1a237e;
            color: white;
            padding: 1.2rem;
            text-align: center;
            font-size: 1.8rem;
            font-weight: bold;
        }

        .container {
            max-width: 900px;
            margin: 2rem auto 6rem auto;
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        form {
            margin-bottom: 2rem;
            text-align: center;
        }

        input[type="text"] {
            padding: 10px;
            width: 60%;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
        }

        input[type="submit"] {
            background-color: #1a237e;
            color: white;
            padding: 10px 20px;
            border: none;
            margin-left: 10px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .medicine-card {
            background: #e8eaf6;
            border-left: 6px solid #1a237e;
            margin-bottom: 1.2rem;
            padding: 1rem 1.5rem;
            border-radius: 10px;
        }

        .medicine-card h3 {
            margin: 0;
            color: #0d47a1;
        }

        .medicine-card p {
            margin: 6px 0;
        }

        .button-container {
            position: sticky;
            bottom: 0;
            background: white;
            padding: 1rem 0;
            border-top: 1px solid #ccc;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.06);
            display: flex;
            justify-content: space-evenly;
            z-index: 100;
        }

        .button-container a {
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s, transform 0.2s;
        }

        .button-container a:hover {
            transform: scale(1.05);
        }

        .go-back { background-color: #546e7a; } /* grey blue */
        .cart { background-color: #00796b; }     /* teal */
        .pay { background-color: #5e35b1; }       /* purple */

    </style>
</head>
<body>

<header>View Medication by Cattle ID</header>

<div class="container">
    <form method="get" action="">
        <input type="text" name="cattle_id" placeholder="Enter Cattle ID" value="<%= cattleId != null ? cattleId : "" %>" required />
        <input type="submit" value="Search" />
    </form>

<%
    if (cattleId != null && !cattleId.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

            String sql = "SELECT * FROM prescriptions WHERE cattle_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, cattleId);
            rs = ps.executeQuery();

            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
%>
    <div class="medicine-card">
        <h3><i class="fas fa-pills"></i> <%= rs.getString("medicine_name") %></h3>
        <p><strong>Dosage:</strong> <%= rs.getString("dosage") %></p>
        <p><strong>Instructions:</strong> <%= rs.getString("instructions") %></p>
        <p><strong>Date Prescribed:</strong> <%= rs.getDate("date_prescribed") %></p>
    </div>
<%
            }
            if (!hasResults) {
%>
    <p style="text-align:center; color: #c62828;">No prescriptions found for Cattle ID: <%= cattleId %></p>
<%
            }
        } catch (Exception e) {
            out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
%>
</div>

<div class="button-container">
    <a href="user_dashboard.jsp" class="go-back"><i class="fas fa-arrow-left"></i> Go Back</a>
   
    <a href="payments.jsp" class="pay"><i class="fas fa-credit-card"></i> Pay</a>
</div>

</body>
</html>


