<%-- 
    Document   : delete_account_simulate
    Created on : 8 Aug 2025, 6:59:05 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Simulate account deletion
    session.invalidate(); // Clear session
    response.sendRedirect("user_login1.jsp?message=Account+deleted+successfully");
%>
