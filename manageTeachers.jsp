<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Teacher" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Teacher> teachers = (List<Teacher>) request.getAttribute("teachers");
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Manage Teachers</title>
<link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">&#127979; CIMS</a>
    <nav>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="StudentServlet">Students</a>
        <a href="TeacherServlet" class="active">Teachers</a>
        <a href="ExamServlet">Exams</a>
        <a href="PaymentServlet">Payments</a>
        <a href="GuardianServlet">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>
<main class="container">
    <div class="page-header"><h1>Teachers</h1></div>
    <div class="card">
        <h2 style="margin-bottom:1rem">Add Teacher</h2>
        <form method="post" action="TeacherServlet">
            <div class="form-grid">
                <div class="form-group"><label>Full Name</label>
                    <input type="text" name="tName" required></div>
                <div class="form-group"><label>Address</label>
                    <input type="text" name="address" required></div>
                <div class="form-group"><label>Phone</label>
                    <input type="tel" name="phone" required></div>
                <div class="form-group"><label>Salary</label>
                    <input type="number" name="salary" step="0.01" required></div>
            </div>
            <div style="margin-top:1rem">
                <button type="submit" class="btn btn-primary">Add Teacher</button>
            </div>
        </form>
    </div>
    <div class="card"><div class="table-wrap">
        <table>
            <thead><tr>
                <th>ID</th><th>Name</th><th>Address</th>
                <th>Phone</th><th>Salary</th><th>Action</th>
            </tr></thead>
            <tbody>
            <% if (teachers != null) { for (Teacher t : teachers) { %>
                <tr>
                    <td><%= t.getTId() %></td>
                    <td><%= t.getTName() %></td>
                    <td><%= t.getAddress() %></td>
                    <td><%= t.getPhone() %></td>
                    <td>Rs.<%= t.getSalary() %></td>
                    <td>
                        <a href="TeacherServlet?action=delete&id=<%= t.getTId() %>"
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Delete?')">Delete</a>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div></div>
</main></body></html>
