<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Student" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Student> students = (List<Student>) request.getAttribute("students");
    String errorMsg = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Guardian - CIMS</title>
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
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
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
        .success-msg {
            background: #e6fffa;
            color: #276749;
            border: 1px solid #9ae6b4;
            border-radius: 6px;
            padding: 10px;
            margin-bottom: 15px;
        }
        .error-msg {
            background: #fff5f5;
            color: #c53030;
            border: 1px solid #fed7d7;
            border-radius: 6px;
            padding: 10px;
            margin-bottom: 15px;
        }
        .info-note {
            background: #ebf8ff;
            padding: 10px;
            border-radius: 6px;
            font-size: 13px;
            margin-top: 15px;
        }
    </style>
    <script>
        function validateForm() {
            var name = document.getElementById('name').value;
            var phone = document.getElementById('phone').value;
            var email = document.getElementById('email').value;
            var studentId = document.getElementById('studentId').value;
            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;
            
            if (name.trim() === '') {
                alert('Please enter guardian name');
                return false;
            }
            if (phone.trim() === '') {
                alert('Please enter phone number');
                return false;
            }
            if (email.trim() === '') {
                alert('Please enter email');
                return false;
            }
            if (!studentId) {
                alert('Please select a student');
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
        
        function generateUsername() {
            var name = document.getElementById('name').value;
            if (name) {
                var username = name.toLowerCase().replace(/\s/g, '.');
                document.getElementById('username').value = username;
            } else {
                alert('Please enter guardian name first');
            }
        }
        
        function generatePassword() {
            var name = document.getElementById('name').value;
            if (name) {
                var pwd = name.toLowerCase().replace(/\s/g, '') + '@123';
                document.getElementById('password').value = pwd;
            } else {
                alert('Please enter guardian name first');
            }
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
        <a href="GuardianServlet">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="page-header">
        <h1>👨‍👩‍👧 Add New Guardian</h1>
        <a href="GuardianServlet" class="btn btn-secondary">← Back to Guardians</a>
    </div>
    
    <% if (successMsg != null) { %>
        <div class="success-msg">✅ <%= successMsg %></div>
    <% } %>
    
    <% if (errorMsg != null) { %>
        <div class="error-msg">❌ <%= errorMsg %></div>
    <% } %>
    
    <div class="card">
        <form method="post" action="GuardianServlet" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="add">
            
            <div class="form-group">
                <label>Select Student *</label>
                <select name="studentId" id="studentId" required>
                    <option value="">-- Select Student --</option>
                    <% if (students != null && !students.isEmpty()) {
                        for (Student s : students) { %>
                            <option value="<%= s.getStId() %>">
                                <%= s.getName() %> (ID: <%= s.getStId() %>)
                            </option>
                    <%   }
                       } %>
                </select>
                <div class="info-note">This guardian will be linked to this student</div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Guardian Name *</label>
                    <input type="text" name="name" id="name" required placeholder="Enter guardian full name">
                </div>
                <div class="form-group">
                    <label>Phone Number *</label>
                    <input type="tel" name="phone" id="phone" required placeholder="Enter phone number">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Email *</label>
                    <input type="email" name="email" id="email" required placeholder="Enter email address">
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <input type="text" name="address" placeholder="Enter address">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Username *</label>
                    <div style="display: flex; gap: 5px;">
                        <input type="text" name="username" id="username" required style="flex: 1;" placeholder="Enter username">
                        <button type="button" class="btn btn-secondary" onclick="generateUsername()">Suggest</button>
                    </div>
                    <div class="info-note">Guardian will use this to login</div>
                </div>
                <div class="form-group">
                    <label>Password *</label>
                    <div style="display: flex; gap: 5px;">
                        <input type="text" name="password" id="password" required style="flex: 1;" placeholder="Enter password">
                        <button type="button" class="btn btn-secondary" onclick="generatePassword()">Suggest</button>
                    </div>
                    <div class="info-note">Min 4 characters</div>
                </div>
            </div>
            
            <div class="info-note">
                <strong>ℹ️ Note:</strong> After adding, the guardian can login using the username and password to view their ward's information and pay fees.
            </div>
            
            <div style="margin-top: 20px;">
                <button type="submit" class="btn btn-primary">➕ Add Guardian</button>
                <a href="GuardianServlet" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</main>

</body>
</html>