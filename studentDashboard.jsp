<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Attendance, model.Material" %>

<%
    // Check if user is logged in and has student role
    if (session.getAttribute("role") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get attributes from request (set by servlets)
    List<Attendance> attList = (List<Attendance>) request.getAttribute("attendanceList");
    List<Material> materials = (List<Material>) request.getAttribute("materials");
    
    // If attributes are null, try to get from session as fallback
    if (attList == null) {
        attList = (List<Attendance>) session.getAttribute("attendanceList");
    }
    if (materials == null) {
        materials = (List<Material>) session.getAttribute("materials");
    }
    
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .welcome-banner {
            background: linear-gradient(135deg, #1a3c5e 0%, #2a7abf 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
        }
        .welcome-banner h1 {
            margin-bottom: 0.5rem;
        }
        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1a3c5e;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 3px solid #2a7abf;
            display: inline-block;
        }
        .empty-message {
            text-align: center;
            padding: 2rem;
            color: #718096;
            font-style: italic;
        }
        .btn-group {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }
        .action-card {
            background: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            flex: 1;
            min-width: 150px;
            transition: transform 0.2s;
        }
        .action-card:hover {
            transform: translateY(-2px);
        }
        .action-card .icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .action-card .action-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .stat-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .stat-summary-item {
            background: white;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .stat-summary-item .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            color: #2a7abf;
        }
        .stat-summary-item .stat-label {
            font-size: 0.85rem;
            color: #718096;
        }
    </style>
</head>
<body>

<header class="navbar">
    <a class="brand" href="StudentDashboardServlet">🏫 CIMS</a>
    <nav>
        <a href="StudentDashboardServlet" class="active">Dashboard</a>
        <a href="AttendanceServlet">My Attendance</a>
        <a href="MaterialServlet">Study Material</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="welcome-banner">
        <h1>Welcome, <%= username != null ? username : "Student" %>!</h1>
        <p>Your learning journey continues. Track your progress and access study materials here.</p>
    </div>
    
    <div class="stat-summary">
        <div class="stat-summary-item">
            <div class="stat-number">
                <%= attList != null ? attList.size() : 0 %>
            </div>
            <div class="stat-label">Total Attendance Records</div>
        </div>
        <div class="stat-summary-item">
            <div class="stat-number">
                <%= materials != null ? materials.size() : 0 %>
            </div>
            <div class="stat-label">Available Study Materials</div>
        </div>
        <div class="stat-summary-item">
            <div class="stat-number">
                <% 
                    int presentCount = 0;
                    if (attList != null) {
                        for (Attendance a : attList) {
                            if ("Present".equals(a.getStatus())) presentCount++;
                        }
                    }
                    int totalAtt = attList != null ? attList.size() : 0;
                    int attendancePercent = totalAtt > 0 ? (presentCount * 100 / totalAtt) : 0;
                %>
                <%= attendancePercent %>% 
            </div>
            <div class="stat-label">Attendance Rate</div>
        </div>
    </div>

    <% if (attList != null && !attList.isEmpty()) { %>
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
            <h2 class="section-title">📋 Recent Attendance</h2>
            <a href="AttendanceServlet" class="btn btn-primary btn-sm">View All</a>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Subject ID</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int count = 0;
                        for (Attendance a : attList) { 
                            if (count++ >= 5) break;
                    %>
                    <tr>
                        <td><%= a.getAttDate() %></td>
                        <td><%= a.getSId() %></td>
                        <td>
                            <span class="badge <%= "Present".equals(a.getStatus()) ? "badge-success" : "badge-danger" %>">
                                <%= a.getStatus() %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
    <div class="card">
        <h2 class="section-title">📋 My Attendance</h2>
        <div class="empty-message">
            <p>No attendance records found yet.</p>
            <p style="font-size: 0.85rem;">Attendance will appear here once your teacher marks it.</p>
        </div>
    </div>
    <% } %>

    <% if (materials != null && !materials.isEmpty()) { %>
    <div class="card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
            <h2 class="section-title">📚 Study Materials</h2>
            <a href="MaterialServlet" class="btn btn-primary btn-sm">View All</a>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Link</th>
                        <th>Upload Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int count = 0;
                        for (Material m : materials) { 
                            if (count++ >= 5) break;
                    %>
                    <tr>
                        <td><strong><%= m.getTitle() %></strong></td>
                        <td><%= m.getDescription() != null ? m.getDescription() : "-" %></td>
                        <td>
                            <% if (m.getFileLink() != null && !m.getFileLink().isEmpty()) { %>
                                <a href="<%= m.getFileLink() %>" target="_blank" class="btn btn-sm btn-primary">View</a>
                            <% } else { %>
                                <span class="badge">No link</span>
                            <% } %>
                        </td>
                        <td><%= m.getUploadDate() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
    <div class="card">
        <h2 class="section-title">📚 Study Materials</h2>
        <div class="empty-message">
            <p>No study materials uploaded yet.</p>
            <p style="font-size: 0.85rem;">Check back later for new learning resources.</p>
        </div>
    </div>
    <% } %>
    
    <div class="card">
        <h2 class="section-title">⚡ Quick Actions</h2>
        <div class="btn-group">
            <a href="AttendanceServlet" class="btn btn-primary">📋 View Full Attendance</a>
            <a href="MaterialServlet" class="btn btn-primary">📚 Browse All Materials</a>
        </div>
    </div>
</main>

</body>
</html>