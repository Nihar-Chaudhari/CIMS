<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (!"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html><html lang="en">
<head><meta charset="UTF-8"><title>Teacher Dashboard</title>
<link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="navbar">
    <a class="brand" href="teacherDashboard.jsp">&#127979; CIMS</a>
    <nav>
        <a href="teacherDashboard.jsp" class="active">Dashboard</a>
        <a href="AttendanceServlet">Attendance</a>
        <a href="MaterialServlet">Material</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>
<main class="container">
    <div class="page-header">
        <h1>Welcome, Teacher <%= session.getAttribute("username") %></h1>
    </div>
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon">&#128203;</div>
            <div class="stat-info">
                <div class="label">Mark Attendance</div>
                <div class="value"><a href="AttendanceServlet"
                    class="btn btn-primary" style="font-size:0.85rem">Go</a></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">&#128218;</div>
            <div class="stat-info">
                <div class="label">Upload Material</div>
                <div class="value"><a href="MaterialServlet"
                    class="btn btn-primary" style="font-size:0.85rem">Go</a></div>
            </div>
        </div>
    </div>
</main></body></html>
