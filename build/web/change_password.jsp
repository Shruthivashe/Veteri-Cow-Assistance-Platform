<%-- 
    Document   : change_password
    Created on : 8 Aug 2025, 6:57:06 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("new_password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "Root@123");
        PreparedStatement ps = con.prepareStatement("UPDATE users SET password=? WHERE username=?");
        ps.setString(1, password);
        ps.setString(2, username);
        int rows = ps.executeUpdate();
        response.sendRedirect("profile.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
