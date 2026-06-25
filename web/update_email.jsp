<%-- 
    Document   : update_email
    Created on : 8 Aug 2025, 7:23:38 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
        PreparedStatement ps = con.prepareStatement("UPDATE users SET email=? WHERE username=?");
        ps.setString(1, email);
        ps.setString(2, username);
        int rows = ps.executeUpdate();
        response.sendRedirect("profile.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
