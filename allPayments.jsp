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
    <title>All Payments - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">🏫 CIMS</a>
    <nav>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="StudentServlet">Students</a>
        <a href="TeacherServlet">Teachers</a>
        <a href="ExamServlet">Exams</a>
        <a href="PaymentServlet" class="active">Payments</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="page-header">
        <h1>💰 All Payments</h1>
    </div>
    
    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Student Name</th>
                        <th>Student ID</th>
                        <th>Payment Type</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (payments != null && !payments.isEmpty()) { 
                        for (String[] p : payments) { %>
                        <tr>
                            <td>#<%= p[0] %></td>
                            <td><strong><%= p[1] %></strong></td>
                            <td><%= p[2] %></td>
                            <td>
                                <% if ("Cash".equals(p[2])) { %>
                                    💵 Cash
                                <% } else if ("Card".equals(p[2])) { %>
                                    💳 Card
                                <% } else if ("UPI".equals(p[2])) { %>
                                    📱 UPI
                                <% } else { %>
                                    <%= p[2] %>
                                <% } %>
                            </td>
                        </tr>
                    <% } 
                    } else { %>
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 2rem;">
                                No payments recorded yet.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>