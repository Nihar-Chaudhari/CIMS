<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map, model.Student, model.Attendance" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<%
    if (session.getAttribute("role") == null || !"teacher".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get attributes from request
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Map<String, Object>> subjects = (List<Map<String, Object>>) request.getAttribute("subjects");
    List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("attendanceList");
    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");
    
    // Initialize empty lists if null
    if (students == null) students = new java.util.ArrayList<>();
    if (subjects == null) subjects = new java.util.ArrayList<>();
    if (attendanceList == null) attendanceList = new java.util.ArrayList<>();
    
    // Get today's date for default value
    String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance - CIMS</title>
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
        .form-group select, .form-group input {
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
        .btn-primary:hover {
            background: #1e5a8f;
        }
        .present-badge {
            background: #f0fff4;
            color: #276749;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
        }
        .absent-badge {
            background: #fff5f5;
            color: #c53030;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
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
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        th {
            background: #1a3c5e;
            color: white;
        }
        .student-select {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            padding: 10px;
            background: white;
        }
        .student-checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px;
            border-bottom: 1px solid #e2e8f0;
        }
        .student-checkbox:last-child {
            border-bottom: none;
        }
        .student-checkbox input {
            width: 18px;
            height: 18px;
        }
        .student-checkbox label {
            cursor: pointer;
            flex: 1;
        }
        .student-name {
            font-weight: 500;
        }
        .student-id {
            font-size: 12px;
            color: #718096;
            margin-left: 8px;
        }
        .select-all {
            margin-bottom: 10px;
            padding: 5px 10px;
            background: #e2e8f0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
        }
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            border: none;
            background: none;
            font-size: 14px;
            font-weight: 500;
        }
        .tab.active {
            color: #2a7abf;
            border-bottom: 2px solid #2a7abf;
            margin-bottom: -2px;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
    <script>
        function toggleAll(source) {
            var checkboxes = document.getElementsByName('presentIds');
            for (var i = 0; i < checkboxes.length; i++) {
                checkboxes[i].checked = source.checked;
            }
        }
        
        function validateBatchForm() {
            var sId = document.getElementById('batchSId').value;
            var attDate = document.getElementById('batchAttDate').value;
            
            if (!sId) {
                alert('Please select a subject');
                return false;
            }
            if (!attDate) {
                alert('Please select a date');
                return false;
            }
            return true;
        }
        
        function validateSingleForm() {
            var stId = document.getElementById('singleStId').value;
            var sId = document.getElementById('singleSId').value;
            var attDate = document.getElementById('singleAttDate').value;
            
            if (!stId) {
                alert('Please select a student');
                return false;
            }
            if (!sId) {
                alert('Please select a subject');
                return false;
            }
            if (!attDate) {
                alert('Please select a date');
                return false;
            }
            return true;
        }
        
        function showTab(tabName) {
            var tabContents = document.getElementsByClassName('tab-content');
            for (var i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove('active');
            }
            var tabs = document.getElementsByClassName('tab');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            document.getElementById(tabName + '-content').classList.add('active');
            event.target.classList.add('active');
        }
    </script>
</head>
<body>

<header class="navbar">
    <a class="brand" href="teacherDashboard.jsp">🏫 CIMS</a>
    <nav>
        <a href="teacherDashboard.jsp">Dashboard</a>
        <a href="AttendanceServlet" class="active">Attendance</a>
        <a href="MaterialServlet">Material</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="page-header">
        <h1>📋 Mark Student Attendance</h1>
    </div>
    
    <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div class="success-msg">✅ <%= successMsg %></div>
    <% } %>
    
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="error-msg">❌ <%= errorMsg %></div>
    <% } %>
    
    <div class="card">
        <div class="tabs">
            <button class="tab active" onclick="showTab('batch')">📝 Batch Attendance</button>
            <button class="tab" onclick="showTab('single')">👤 Single Student</button>
        </div>
        
        <!-- Batch Attendance Tab - Mark multiple students at once -->
        <div id="batch-content" class="tab-content active">
            <h3 style="margin-bottom: 15px;">Mark Attendance for Multiple Students</h3>
            
            <% if (students.isEmpty()) { %>
                <div class="info-note">
                    ⚠️ No students assigned to you. Please contact admin to assign classes.
                </div>
            <% } else { %>
                <form method="post" action="AttendanceServlet" onsubmit="return validateBatchForm()">
                    <input type="hidden" name="action" value="markMultiple">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Select Subject *</label>
                            <select name="sId" id="batchSId" required>
                                <option value="">-- Select Subject --</option>
                                <% if (subjects != null && !subjects.isEmpty()) {
                                    for (Map<String, Object> subject : subjects) { %>
                                        <option value="<%= subject.get("sId") %>">
                                            <%= subject.get("sName") %> - <%= subject.get("className") %>
                                        </option>
                                <%   }
                                   } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Select Date *</label>
                            <input type="date" name="attDate" id="batchAttDate" value="<%= todayDate %>" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Select Present Students:</label>
                        <button type="button" class="select-all" onclick="toggleAll(this)">✓ Select All</button>
                        <div class="student-select">
                            <% for (Student s : students) { %>
                                <div class="student-checkbox">
                                    <input type="checkbox" name="presentIds" value="<%= s.getStId() %>" id="student_<%= s.getStId() %>">
                                    <label for="student_<%= s.getStId() %>">
                                        <span class="student-name"><%= s.getName() %></span>
                                        <span class="student-id">(ID: <%= s.getStId() %>)</span>
                                    </label>
                                </div>
                            <% } %>
                        </div>
                        <div class="info-note">
                            💡 Students not checked will be marked as <strong>Absent</strong>.
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" style="margin-top: 15px;">✅ Mark Attendance</button>
                </form>
            <% } %>
        </div>
        
        <!-- Single Student Tab - Mark attendance for one student -->
        <div id="single-content" class="tab-content">
            <h3 style="margin-bottom: 15px;">Mark Attendance for Single Student</h3>
            
            <form method="post" action="AttendanceServlet" onsubmit="return validateSingleForm()">
                <input type="hidden" name="action" value="markSingle">
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Select Student *</label>
                        <select name="stId" id="singleStId" required>
                            <option value="">-- Select Student --</option>
                            <% if (students != null && !students.isEmpty()) {
                                for (Student s : students) { %>
                                    <option value="<%= s.getStId() %>">
                                        <%= s.getName() %> (ID: <%= s.getStId() %>)
                                    </option>
                            <%   }
                               } else { %>
                                <option value="">No students assigned</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Select Subject *</label>
                        <select name="sId" id="singleSId" required>
                            <option value="">-- Select Subject --</option>
                            <% if (subjects != null && !subjects.isEmpty()) {
                                for (Map<String, Object> subject : subjects) { %>
                                    <option value="<%= subject.get("sId") %>">
                                        <%= subject.get("sName") %> - <%= subject.get("className") %>
                                    </option>
                            <%   }
                               } %>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Select Date *</label>
                        <input type="date" name="attDate" id="singleAttDate" value="<%= todayDate %>" required>
                    </div>
                    <div class="form-group">
                        <label>Status *</label>
                        <select name="status" required>
                            <option value="Present">✅ Present</option>
                            <option value="Absent">❌ Absent</option>
                        </select>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary" style="margin-top: 15px;">✅ Mark Attendance</button>
            </form>
        </div>
    </div>
    
    <!-- Recent Attendance Records -->
    <div class="card">
        <h3 style="margin-bottom: 15px;">📊 Recent Attendance Records</h3>
        <% if (attendanceList.isEmpty()) { %>
            <div style="text-align: center; padding: 40px; color: #718096;">
                No attendance records found.
            </div>
        <% } else { %>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Student ID</th>
                            <th>Subject ID</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            int count = 0;
                            for (Attendance a : attendanceList) { 
                                if (count++ >= 20) break;
                        %>
                        <tr>
                            <td><%= a.getAttDate() %></td>
                            <td><%= a.getStId() %></td>
                            <td><%= a.getSId() %></td>
                            <td>
                                <span class="<%= "Present".equals(a.getStatus()) ? "present-badge" : "absent-badge" %>">
                                    <%= a.getStatus() %>
                                </span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% if (attendanceList.size() > 20) { %>
                    <div class="info-note" style="margin-top: 10px;">
                        Showing last 20 records out of <%= attendanceList.size() %> total.
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</main>

</body>
</html>