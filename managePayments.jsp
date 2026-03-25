<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<String[]> payments = (List<String[]>) request.getAttribute("payments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Payments</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #1a3c5e; color: white; }
        .btn { padding: 8px 16px; background: #2a7abf; color: white; text-decoration: none; border-radius: 4px; display: inline-block; }
        .delete { color: red; text-decoration: none; }
    </style>
</head>
<body>

<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">CIMS</a>
    <nav>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="StudentServlet">Students</a>
        <a href="TeacherServlet">Teachers</a>
        <a href="ExamServlet">Exams</a>
        <a href="PaymentServlet" class="active">Payments</a>
        <a href="GuardianServlet">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <h1>Payment Management</h1>
    <a href="PaymentServlet?action=add" class="btn">+ Add Payment</a>
    <br><br>
    
    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>Student</th><th>Student ID</th><th>Type</th><th>Amount</th><th>Date</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (payments != null && !payments.isEmpty()) {
                    for (String[] p : payments) { %>
                    <tr>
                        <td><%= p[0] %></td>
                        <td><%= p[1] %></td>
                        <td><%= p[2] %></td>
                        <td><%= p[3] %></td>
                        <td>₹<%= p[4] %></td>
                        <td><%= p[5] %></td>
                        <td><a href="PaymentServlet?action=delete&id=<%= p[0] %>" class="delete" onclick="return confirm('Delete?')">Delete</a></td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="7">No payments found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>