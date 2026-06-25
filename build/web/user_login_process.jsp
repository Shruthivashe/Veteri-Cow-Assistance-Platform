<%-- 
    Document   : user_login_process
    Created on : 8 Aug 2025, 7:31:48 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ include file="db_connection.jsp" %>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (conn == null) {
        out.println("Database connection failed. Please try again later.");
        return;
    }

    try {
        String sql = "SELECT * FROM users WHERE username=? AND password=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("username", username);  
            response.sendRedirect("user_dashboard.jsp"); 
        } else {
            response.sendRedirect("user_login.jsp?error=invalid"); 
        }
  } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (Exception e) {
            out.println("Connection Close Error: " + e.getMessage());
        }
    }
%>