<%-- 
    Document   : update_status
    Created on : 8 Aug 2025, 7:25:41 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");

        String sql = "UPDATE appointments_vet SET status = ? WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, id);

        ps.executeUpdate();
        response.sendRedirect("appointments_vet.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
