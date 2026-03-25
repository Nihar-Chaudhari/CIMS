<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Student" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    Student s = (Student) request.getAttribute("student");
    boolean isEdit = (s != null);
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8">
<title><%= isEdit ? "Edit" : "Add" %> Student</title>
<link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">&#127979; CIMS</a>
    <nav>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="StudentServlet" class="active">Students</a>
        <a href="TeacherServlet">Teachers</a>
        <a href="ExamServlet">Exams</a>
        <a href="PaymentServlet">Payments</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>
<main class="container">
    <div class="page-header">
        <h1><%= isEdit ? "Edit Student" : "Add Student" %></h1>
        <a href="StudentServlet" class="btn btn-primary">Back</a>
    </div>
    <div class="card">
    <form method="post" action="StudentServlet">
        <% if (isEdit) { %>
            <input type="hidden" name="stId" value="<%= s.getStId() %>">
        <% } %>
        <div class="form-grid">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" required
                       value="<%= isEdit ? s.getName() : "" %>">
            </div>
            <div class="form-group">
                <label>Date of Birth</label>
                <input type="date" name="dob" required
                       value="<%= isEdit ? s.getDob() : "" %>">
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input type="tel" name="phone" required
                       value="<%= isEdit ? s.getPhone() : "" %>">
            </div>
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" required
                       value="<%= isEdit ? s.getAddress() : "" %>">
            </div>
        </div>
        <div style="margin-top:1rem">
            <button type="submit" class="btn btn-primary">
                <%= isEdit ? "Update Student" : "Save Student" %>
            </button>
        </div>
    </form>
    </div>
</main></body></html>
