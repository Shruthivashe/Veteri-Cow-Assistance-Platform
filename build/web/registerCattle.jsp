<%-- 
    Document   : registerCattle
    Created on : 8 Aug 2025, 7:10:55 pm
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Cattle | Veteri Cow Assist</title>
    <style>
        /* [CSS remains same as before for brevity] */
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: #e8f5e9;
        }

        header {
            background: #2e7d32;
            color: white;
            padding: 1.2rem;
            font-size: 1.6rem;
            text-align: center;
            font-weight: bold;
        }

        .container {
            max-width: 1000px;
            margin: 2rem auto;
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        input, select {
            padding: 0.8rem;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
        }

        button {
            grid-column: span 2;
            padding: 0.8rem;
            background-color: #388e3c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }

        .search-bar {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .search-bar input {
            flex: 1;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .search-bar button {
            background: #00796b;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 0.7rem 1.2rem;
            cursor: pointer;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            padding: 0.75rem;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background: #a5d6a7;
        }

        .action-btn {
            background: #0288d1;
            color: white;
            padding: 0.4rem 0.7rem;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .update {
            background: #f9a825;
        }

        .footer-buttons {
            margin-top: 2rem;
            text-align: left;
        }

        .footer-buttons a {
            background: #33691e;
            color: white;
            padding: 0.7rem 1.2rem;
            text-decoration: none;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

    // Handle form submission
    String cattleId = request.getParameter("cattle_id");
    String breed = request.getParameter("breed");
    String age = request.getParameter("age");
    String gender = request.getParameter("gender");

    if (cattleId != null && breed != null && age != null && gender != null) {
        String insertSQL = "INSERT INTO cattle (cattle_id, breed, age, gender) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(insertSQL);
        ps.setString(1, cattleId);
        ps.setString(2, breed);
        ps.setString(3, age);
        ps.setString(4, gender);
        ps.executeUpdate();
        ps.close();
    }

    // Display all cattle
    String selectSQL = "SELECT * FROM cattle";
    ps = conn.prepareStatement(selectSQL);
    rs = ps.executeQuery();
%>

<header>Register Cattle</header>

<div class="container">
    <form method="post">
        <input type="text" name="cattle_id" placeholder="Cattle ID" required />
        <input type="text" name="breed" placeholder="Breed" required />
        <input type="number" name="age" placeholder="Age (in years)" required />
        <select name="gender" required>
            <option value="">Select Gender</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
        </select>
        <button type="submit">Add Cattle</button>
    </form>

    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Search by Cattle ID or Breed" onkeyup="filterTable()" />
        <button onclick="filterTable()">Search</button>
    </div>

    <table id="cattleTable">
        <thead>
            <tr>
                <th>Cattle ID</th>
                <th>Breed</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getString("cattle_id") %></td>
                <td><%= rs.getString("breed") %></td>
                <td><%= rs.getString("age") %></td>
                <td><%= rs.getString("gender") %></td>
                <td>
                    <form action="viewCattle.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="id" value="<%= rs.getString("cattle_id") %>">
                        <button class="action-btn">View</button>
                    </form>
                    <form action="updateCattle.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="id" value="<%= rs.getString("cattle_id") %>">
                        <button class="action-btn update">Update</button>
                    </form>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="footer-buttons">
        <a href="user_dashboard.jsp">← Back to Dashboard</a>
    </div>
</div>

<%
    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<script>
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const rows = document.querySelectorAll("#cattleTable tbody tr");

        rows.forEach(row => {
            const id = row.cells[0].textContent.toLowerCase();
            const breed = row.cells[1].textContent.toLowerCase();
            row.style.display = (id.includes(input) || breed.includes(input)) ? "" : "none";
        });
    }
</script>

</body>
</html>
