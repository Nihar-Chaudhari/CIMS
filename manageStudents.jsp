<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Student" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Student> students = (List<Student>) request.getAttribute("students");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Students - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .search-box {
            margin-bottom: 1rem;
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
            var rows = document.getElementById('studentTable').getElementsByTagName('tr');
            
            for (var i = 1; i < rows.length; i++) {
                var name = rows[i].getElementsByTagName('td')[1];
                if (name) {
                    var text = name.textContent.toLowerCase();
                    rows[i].style.display = text.indexOf(filter) > -1 ? '' : 'none';
                }
            }
        }
    </script>
</head>
<body>

<header class="navbar">
    <a class="brand" href="adminDashboard.jsp">🏫 CIMS</a>
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
        <h1>📚 Manage Students</h1>
        <a href="addStudent.jsp" class="btn btn-primary">+ Add Student</a>
    </div>
    
    <div class="card">
        <div class="search-box">
            <input type="text" id="search" placeholder="🔍 Search by name..." onkeyup="searchTable()">
        </div>
        
        <div class="table-wrap">
            <table id="studentTable" style="width: 100%;">
                <thead>
                    <tr style="background: #1a3c5e; color: white;">
                        <th style="padding: 10px;">ID</th>
                        <th style="padding: 10px;">Name</th>
                        <th style="padding: 10px;">Phone</th>
                        <th style="padding: 10px;">Username</th>
                        <th style="padding: 10px;">Password</th>
                        <th style="padding: 10px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (students != null && !students.isEmpty()) { 
                        for (Student s : students) { %>
                    <tr style="border-bottom: 1px solid #e2e8f0;">
                        <td style="padding: 10px;"><%= s.getStId() %></td>
                        <td style="padding: 10px;"><strong><%= s.getName() %></strong></td>
                        <td style="padding: 10px;"><%= s.getPhone() != null ? s.getPhone() : "-" %></td>
                        <td style="padding: 10px;">
                            <%= s.getUsername() != null ? s.getUsername() : "-" %>
                            <% if (s.getUsername() != null) { %>
                                <button class="copy-btn" onclick="copyText('<%= s.getUsername() %>', this)">📋</button>
                            <% } %>
                        </td>
                        <td style="padding: 10px;">
                            <% if (s.getPassword() != null) { %>
                                <span class="password-view" onclick="togglePassword(this)" data-pwd="<%= s.getPassword() %>">
                                    ••••••
                                </span>
                                <button class="copy-btn" onclick="copyText('<%= s.getPassword() %>', this)">📋</button>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                        <td style="padding: 10px;">
                            <div class="action-buttons">
                                <a href="StudentServlet?action=edit&id=<%= s.getStId() %>" class="btn btn-sm btn-primary">Edit</a>
                                <a href="StudentServlet?action=delete&id=<%= s.getStId() %>" 
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Delete this student?')">Delete</a>
                            </div>
                        </td>
                    </tr>
                    <% } 
                    } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 40px;">
                            No students found. <a href="addStudent.jsp">Add one</a>
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