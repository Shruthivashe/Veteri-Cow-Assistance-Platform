<%-- 
    Document   : vet_signup_process
    Created on : 8 Aug 2025, 7:50:17 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ include file="db_connection.jsp" %>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String license = request.getParameter("license_no");
    String specialization = request.getParameter("specialization");
    String password = request.getParameter("password");

    try {
        String sql = "INSERT INTO vets (username, email, license_no, specialization, password) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, license);
        ps.setString(4, specialization);
        ps.setString(5, password);

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("vet_login.jsp");
        } else {
            out.println("Vet registration failed.");
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
