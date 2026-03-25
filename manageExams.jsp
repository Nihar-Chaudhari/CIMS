<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Exam" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Exam> exams = (List<Exam>) request.getAttribute("exams");
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Manage Exams</title>
<link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">&#127979; CIMS</a>
    <nav>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="StudentServlet">Students</a>
        <a href="TeacherServlet">Teachers</a>
        <a href="ExamServlet" class="active">Exams</a>
        <a href="PaymentServlet">Payments</a>
        <a href="GuardianServlet">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>
<main class="container">
    <div class="page-header"><h1>Exams</h1></div>
    <div class="card">
        <h2 style="margin-bottom:1rem">Add Exam</h2>
        <form method="post" action="ExamServlet">
            <div class="form-grid">
                <div class="form-group"><label>Exam Name</label>
                    <input type="text" name="examName" required></div>
                <div class="form-group"><label>Year</label>
                    <input type="number" name="year" required></div>
                <div class="form-group"><label>Total Marks</label>
                    <input type="number" name="totalMarks" required></div>
                <div class="form-group"><label>Mode</label>
                    <select name="eMode">
                        <option value="Online">Online</option>
                        <option value="Offline">Offline</option>
                    </select>
                </div>
                <div class="form-group">
                <label>Exam Date</label>
                <input type="date" name="examDate" required>
                </div>
            </div>
            <div style="margin-top:1rem">
                <button type="submit" class="btn btn-primary">Add Exam</button>
            </div>
        </form>
    </div>
    <div class="card"><div class="table-wrap">
        <table>
            <thead><tr>
                <th>ID</th><th>Exam Name</th><th>Year</th>
                <th>Total Marks</th><th>Mode</th><th>Action</th>
            </tr></thead>
            <tbody>
            <% if (exams != null) { for (Exam e : exams) { %>
                <tr>
                    <td><%= e.getEId() %></td>
                    <td><%= e.getExamName() %></td>
                    <td><%= e.getYear() %></td>
                    <td><%= e.getTotalMarks() %></td>
                    <td><%= e.getEMode() %></td>
                    <td>
                        <a href="ExamServlet?action=delete&id=<%= e.getEId() %>"
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Delete?')">Delete</a>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div></div>
</main></body></html>
