<%-- 
    Document   : logout
    Created on : 8 Aug 2025, 7:02:04 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.invalidate();
    response.sendRedirect("index.html");
%>
