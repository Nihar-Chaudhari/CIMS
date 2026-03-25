<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<String[]> guardians = (List<String[]>) request.getAttribute("guardians");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Guardians - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .search-box {
            margin-bottom: 15px;
        }
        .search-box input {
            width: 100%;
            max-width: 300px;
            padding: 8px 12px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .password-view {
            cursor: pointer;
            background: #f0f4f8;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: monospace;
        }
        .copy-btn {
            background: none;
            border: none;
            cursor: pointer;
            margin-left: 5px;
        }
    </style>
    <script>
        function togglePassword(element) {
            var current = element.innerText;
            if (current === '••••••') {
                element.innerText = element.getAttribute('data-pwd');
            } else {
                element.innerText = '••••••';
            }
        }
        
        function copyText(text, btn) {
            navigator.clipboard.writeText(text);
            btn.innerText = '✓';
            setTimeout(() => { btn.innerText = '📋'; }, 1000);
        }
        
        function searchTable() {
            var input = document.getElementById('search');
            var filter = input.value.toLowerCase();
            var rows = document.getElementById('guardianTable').getElementsByTagName('tr');
            
            for (var i = 1; i < rows.length; i++) {
                var name = rows[i].getElementsByTagName('td')[1];
                if (name) {
                    var text = name.textContent.toLowerCase();
                    rows[i].style.display = text.indexOf(filter) > -1 ? '' : 'none';
                }
            }
        }
        
        function confirmDelete(guardianName) {
            return confirm('Delete guardian "' + guardianName + '"? This will also remove their login access.');
        }
    </script>
</head>
<body>

<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">🏫 CIMS</a>
    <nav>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="StudentServlet">Students</a>
        <a href="TeacherServlet">Teachers</a>
        <a href="ExamServlet">Exams</a>
        <a href="PaymentServlet">Payments</a>
        <a href="GuardianServlet" class="active">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="page-header">
        <h1>👨‍👩‍👧 Manage Guardians</h1>
        <a href="addGuardian.jsp" class="btn btn-primary">+ Add Guardian</a>
    </div>
    
    <div class="card">
        <div class="search-box">
            <input type="text" id="search" placeholder="🔍 Search by guardian name..." onkeyup="searchTable()">
        </div>
        
        <div class="table-wrap">
            <table id="guardianTable" style="width: 100%;">
                <thead>
                    <tr style="background: #1a3c5e; color: white;">
                        <th style="padding: 10px;">ID</th>
                        <th style="padding: 10px;">Guardian Name</th>
                        <th style="padding: 10px;">Student</th>
                        <th style="padding: 10px;">Phone</th>
                        <th style="padding: 10px;">Email</th>
                        <th style="padding: 10px;">Username</th>
                        <th style="padding: 10px;">Password</th>
                        <th style="padding: 10px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (guardians != null && !guardians.isEmpty()) { 
                        for (String[] g : guardians) { %>
                    <tr style="border-bottom: 1px solid #e2e8f0;">
                        <td style="padding: 10px;"><%= g[0] %></td>
                        <td style="padding: 10px;"><strong><%= g[1] %></strong></td>
                        <td style="padding: 10px;"><%= g[2] %></td>
                        <td style="padding: 10px;"><%= g[3] %></td>
                        <td style="padding: 10px;"><%= g[4] %></td>
                        <td style="padding: 10px;">
                            <%= g[5] != null ? g[5] : "-" %>
                            <% if (g[5] != null) { %>
                                <button class="copy-btn" onclick="copyText('<%= g[5] %>', this)">📋</button>
                            <% } %>
                        </td>
                        <td style="padding: 10px;">
                            <% if (g[6] != null) { %>
                                <span class="password-view" onclick="togglePassword(this)" data-pwd="<%= g[6] %>">
                                    ••••••
                                </span>
                                <button class="copy-btn" onclick="copyText('<%= g[6] %>', this)">📋</button>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td style="padding: 10px;">
                            <div class="action-buttons">
                                <a href="GuardianServlet?action=edit&id=<%= g[0] %>" class="btn btn-sm btn-primary">Edit</a>
                                <a href="GuardianServlet?action=delete&id=<%= g[0] %>" 
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirmDelete('<%= g[1] %>')">Delete</a>
                            </div>
                        </td>
                    </tr>
                    <% } 
                    } else { %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px;">
                            No guardians found. <a href="addGuardian.jsp">Add one</a>
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