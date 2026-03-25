<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // If already logged in, redirect to appropriate dashboard
    if (session.getAttribute("role") != null) {
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("adminDashboard.jsp");
        } else if ("teacher".equals(role)) {
            response.sendRedirect("teacherDashboard.jsp");
        } else if ("student".equals(role)) {
            response.sendRedirect("studentDashboard.jsp");
        } else if ("guardian".equals(role)) {
            response.sendRedirect("guardianDashboard.jsp");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CIMS Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-wrapper">
        <div class="login-card">
            <div class="logo">
                <h2>🏫 CIMS</h2>
                <p>Coaching Institute Management System</p>
            </div>
            
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="error-msg">
                    ❌ <%= error %>
                </div>
            <% } %>
            
            <form method="post" action="LoginServlet">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required autofocus 
                           placeholder="Enter username">
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required 
                           placeholder="Enter password">
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            
            <div class="info-text" style="margin-top: 15px; text-align: center; font-size: 12px; color: #718096;">
                <p>Demo Accounts:</p>
                <p>Admin: admin / admin123</p>
                <p>Teacher: teacher1 / teacher123</p>
                <p>Student: rahul.sharma / student123</p>
            </div>
        </div>
    </div>
</body>
</html>