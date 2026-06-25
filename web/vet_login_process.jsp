<%-- 
    Document   : vet_login_process
    Created on : 8 Aug 2025, 7:45:36 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        String sql = "SELECT * FROM vets WHERE username=? AND password=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("user", username);
            response.sendRedirect("vet_dashboard.jsp");
        } else {
            out.println("<h3>Invalid credentials. <a href='vet_login.jsp'>Try again</a></h3>");
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
