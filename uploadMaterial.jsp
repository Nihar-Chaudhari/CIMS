<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Material" %>

<%
    if (session.getAttribute("role") == null || !"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Material> materials = (List<Material>) request.getAttribute("materials");
    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Study Material - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .success-msg {
            background: #e6fffa;
            color: #276749;
            border: 1px solid #9ae6b4;
            border-radius: 6px;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
        }
        .info-note {
            background: #ebf8ff;
            color: #2c5282;
            border: 1px solid #bee3f8;
            border-radius: 6px;
            padding: 0.75rem 1rem;
            margin-top: 1rem;
            font-size: 0.85rem;
        }
        .file-link-help {
            font-size: 0.75rem;
            color: #718096;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>

<header class="navbar">
    <a class="brand" href="teacherDashboard.jsp">🏫 CIMS</a>
    <nav>
        <a href="teacherDashboard.jsp">Dashboard</a>
        <a href="AttendanceServlet">Attendance</a>
        <a href="MaterialServlet" class="active">Material</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="page-header">
        <h1>📚 Study Material Management</h1>
    </div>
    
    <% if (successMsg != null) { %>
        <div class="success-msg">
            ✅ <%= successMsg %>
        </div>
    <% } %>
    
    <% if (errorMsg != null) { %>
        <div class="error-msg">
            ❌ <%= errorMsg %>
        </div>
    <% } %>
    
    <div class="card">
        <h2 style="margin-bottom: 1rem;">📤 Upload New Material</h2>
        <form method="post" action="MaterialServlet">
            <div class="form-grid">
                <div class="form-group">
                    <label>Subject ID *</label>
                    <input type="number" name="sId" required placeholder="Enter subject ID">
                </div>
                <div class="form-group">
                    <label>Title *</label>
                    <input type="text" name="title" required placeholder="e.g., Chapter 1 Notes">
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <input type="text" name="description" placeholder="Brief description of material">
                </div>
                <div class="form-group">
                    <label>File Link (URL)</label>
                    <input type="text" name="fileLink" placeholder="https://drive.google.com/...">
                    <div class="file-link-help">
                        💡 Paste Google Drive link, YouTube video, or any resource URL
                    </div>
                </div>
            </div>
            <div style="margin-top: 1rem;">
                <button type="submit" class="btn btn-primary">📤 Upload Material</button>
            </div>
        </form>
        <div class="info-note">
            <strong>ℹ️ Note:</strong> Students will be able to view uploaded materials immediately after upload.
        </div>
    </div>

    <div class="card">
        <h2 style="margin-bottom: 1rem;">📋 All Uploaded Materials</h2>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Subject ID</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Link</th>
                        <th>Upload Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (materials != null && !materials.isEmpty()) { 
                        for (Material m : materials) { %>
                    <tr>
                        <td><%= m.getMId() %></td>
                        <td><%= m.getSId() %></td>
                        <td><strong><%= m.getTitle() %></strong></td>
                        <td><%= m.getDescription() != null ? m.getDescription() : "-" %></td>
                        <td>
                            <% if (m.getFileLink() != null && !m.getFileLink().isEmpty()) { %>
                                <a href="<%= m.getFileLink() %>" target="_blank" class="btn btn-sm btn-primary">🔗 View</a>
                            <% } else { %>
                                <span class="badge">No link</span>
                            <% } %>
                        </td>
                        <td><%= m.getUploadDate() %></td>
                    </tr>
                    <% } 
                    } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No materials uploaded yet.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>