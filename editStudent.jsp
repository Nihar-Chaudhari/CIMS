<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Student" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Student student = (Student) request.getAttribute("student");
    String errorMsg = (String) request.getAttribute("errorMsg");
    
    if (student == null) {
        response.sendRedirect("StudentServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Student - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #1a3c5e;
        }
        .form-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #2a7abf;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .error-msg {
            background: #fff5f5;
            color: #c53030;
            border: 1px solid #fed7d7;
            border-radius: 6px;
            padding: 10px;
            margin-bottom: 15px;
        }
        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-primary {
            background: #2a7abf;
            color: white;
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #2d3748;
        }
        .btn-danger {
            background: #c53030;
            color: white;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .student-id {
            background: #e2e8f0;
            padding: 5px 10px;
            border-radius: 5px;
            display: inline-block;
            font-size: 14px;
        }
        .info-text {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }
        .credential-box {
            background: #f0f4f8;
            padding: 10px;
            border-radius: 6px;
            margin-top: 10px;
        }
    </style>
    <script>
        function validateForm() {
            var name = document.getElementById('name').value;
            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;
            
            if (name.trim() === '') {
                alert('Please enter student name');
                return false;
            }
            if (username.trim() === '') {
                alert('Please enter username');
                return false;
            }
            if (password.trim() === '') {
                alert('Please enter password');
                return false;
            }
            if (password.length < 4) {
                alert('Password must be at least 4 characters');
                return false;
            }
            return true;
        }
        
        function generatePassword() {
            var name = document.getElementById('name').value;
            if (name) {
                var pwd = name.toLowerCase().replace(/\s/g, '') + '@123';
                document.getElementById('password').value = pwd;
            } else {
                alert('Please enter name first');
            }
        }
        
        function generateUsername() {
            var name = document.getElementById('name').value;
            if (name) {
                var username = name.toLowerCase().replace(/\s/g, '.');
                document.getElementById('username').value = username;
            } else {
                alert('Please enter name first');
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
        <h1>✏️ Edit Student</h1>
        <a href="StudentServlet" class="btn btn-secondary">← Back</a>
    </div>
    
    <% if (errorMsg != null) { %>
        <div class="error-msg">
            ❌ <%= errorMsg %>
        </div>
    <% } %>
    
    <div class="card">
        <form method="post" action="StudentServlet" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="stId" value="<%= student.getStId() %>">
            
            <div class="form-group">
                <label>Student ID</label>
                <div class="student-id">ID: <%= student.getStId() %></div>
            </div>
            
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="name" id="name" required 
                       value="<%= student.getName() %>">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob" value="<%= student.getDob() != null ? student.getDob() : "" %>">
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" value="<%= student.getPhone() != null ? student.getPhone() : "" %>">
                </div>
            </div>
            
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" value="<%= student.getAddress() != null ? student.getAddress() : "" %>">
            </div>
            
            <div class="credential-box">
                <h3 style="margin-bottom: 15px;">🔐 Login Credentials (Stored in Users Table)</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Username *</label>
                        <div style="display: flex; gap: 5px;">
                            <input type="text" name="username" id="username" required 
                                   value="<%= student.getUsername() != null ? student.getUsername() : "" %>"
                                   style="flex: 1;">
                            <button type="button" class="btn btn-secondary" onclick="generateUsername()" style="padding: 8px 12px;">Suggest</button>
                        </div>
                        <div class="info-text">Student will use this username to login</div>
                    </div>
                    <div class="form-group">
                        <label>Password *</label>
                        <div style="display: flex; gap: 5px;">
                            <input type="text" name="password" id="password" required 
                                   value="<%= student.getPassword() != null ? student.getPassword() : "" %>"
                                   style="flex: 1;">
                            <button type="button" class="btn btn-secondary" onclick="generatePassword()" style="padding: 8px 12px;">Suggest</button>
                        </div>
                        <div class="info-text">Student will use this password to login (min 4 characters)</div>
                    </div>
                </div>
                
                <div class="info-text" style="margin-top: 10px;">
                    ⚠️ When you update credentials, the Users table will be automatically updated with student_id reference.
                </div>
            </div>
            
            <div class="action-buttons">
                <button type="submit" class="btn btn-primary">💾 Update Student</button>
                <a href="StudentServlet" class="btn btn-secondary">Cancel</a>
                <a href="StudentServlet?action=delete&id=<%= student.getStId() %>" 
                   class="btn btn-danger" 
                   onclick="return confirm('Delete this student?\nThis will also remove their login access from Users table!')">
                   🗑️ Delete Student
                </a>
            </div>
        </form>
    </div>
</main>

</body>
</html>