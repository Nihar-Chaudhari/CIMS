<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="dao.DBConnection, java.sql.*" %>

<%
    if (session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get counts for dashboard
    int students = 0, teachers = 0, exams = 0, payments = 0;
    try (Connection con = DBConnection.getConnection()) {
        ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM Students");
        if (rs.next()) students = rs.getInt(1);
        
        rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM Teachers");
        if (rs.next()) teachers = rs.getInt(1);
        
        rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM Exams");
        if (rs.next()) exams = rs.getInt(1);
        
        rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM Payment");
        if (rs.next()) payments = rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .action-btn {
            background: #2a7abf;
            color: white;
            padding: 12px;
            text-align: center;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.2s;
            font-weight: 600;
        }
        .action-btn:hover {
            background: #1e5a8f;
            transform: translateY(-2px);
        }
        .action-btn.green {
            background: #276749;
        }
        .action-btn.green:hover {
            background: #1f543d;
        }
        .action-btn.orange {
            background: #dd6b20;
        }
        .action-btn.orange:hover {
            background: #c05a1a;
        }
    </style>
</head>
<body>

<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">🏫 CIMS</a>
    <nav>
        <a href="adminDashboard.jsp" class="active">Dashboard</a>
        <a href="StudentServlet">Students</a>
        <a href="TeacherServlet">Teachers</a>
        <a href="ExamServlet">Exams</a>
        <a href="PaymentServlet">Payments</a>
        <a href="GuardianServlet">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="welcome-banner">
        <h1>Welcome, <%= session.getAttribute("username") %>!</h1>
        <p>Manage students, teachers, exams, payments, and guardians from here.</p>
    </div>
    
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon">👨‍🎓</div>
            <div class="stat-info">
                <div class="label">Total Students</div>
                <div class="value"><%= students %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">👨‍🏫</div>
            <div class="stat-info">
                <div class="label">Total Teachers</div>
                <div class="value"><%= teachers %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📝</div>
            <div class="stat-info">
                <div class="label">Total Exams</div>
                <div class="value"><%= exams %></div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">💰</div>
            <div class="stat-info">
                <div class="label">Total Payments</div>
                <div class="value"><%= payments %></div>
            </div>
        </div>
    </div>
    
    <div class="card">
        <h2>Quick Actions</h2>
        <div class="quick-actions">
            <a href="StudentServlet" class="action-btn">📚 Manage Students</a>
            <a href="TeacherServlet" class="action-btn">👨‍🏫 Manage Teachers</a>
            <a href="ExamServlet" class="action-btn">📝 Manage Exams</a>
            <a href="PaymentServlet" class="action-btn">💰 View Payments</a>
            <a href="PaymentServlet?action=add" class="action-btn green">➕ Add Payment</a>
            <a href="GuardianServlet" class="action-btn orange">👨‍👩‍👧 Manage Guardians</a>
        </div>
    </div>
</main>

</body>
</html>