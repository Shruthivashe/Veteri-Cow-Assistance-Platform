<%-- 
    Document   : db_connection
    Created on : 8 Aug 2025, 6:58:26 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
   Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbURL = "jdbc:mysql://localhost:3306/mysql"; // Ensure correct DB name
        String dbUser = "root";
        String dbPass = "Root@123";
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        application.setAttribute("conn", conn); // optional, only if reused globally
    } catch (Exception e) {
        out.println("Database Connection Failed: " + e.getMessage());
    }
%>
