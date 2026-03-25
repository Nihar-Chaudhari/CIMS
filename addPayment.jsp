<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Student, java.time.LocalDate, java.time.format.DateTimeFormatter" %>

<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Student> students = (List<Student>) request.getAttribute("students");
    String errorMsg = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
    
    // Get today's date for default value
    String todayDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Payment - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1a3c5e;
        }
        .form-group select, .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #cbd5e0;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-group select:focus, .form-group input:focus {
            outline: none;
            border-color: #2a7abf;
            box-shadow: 0 0 0 3px rgba(42,122,191,0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        .btn-primary {
            background: #2a7abf;
            color: white;
        }
        .btn-primary:hover {
            background: #1e5a8f;
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #2d3748;
        }
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        .success-msg {
            background: #e6fffa;
            color: #276749;
            border: 1px solid #9ae6b4;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 20px;
        }
        .error-msg {
            background: #fff5f5;
            color: #c53030;
            border: 1px solid #fed7d7;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 20px;
        }
        .info-note {
            background: #ebf8ff;
            padding: 12px;
            border-radius: 6px;
            font-size: 13px;
            margin-top: 20px;
        }
        .payment-summary {
            background: #f0f4f8;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .fee-amount {
            font-size: 24px;
            font-weight: bold;
            color: #276749;
        }
        .card-details, .upi-details {
            display: none;
            animation: fadeIn 0.3s ease;
            background: #f8fafc;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .date-note {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }
    </style>
    <script>
        function showPaymentDetails() {
            var type = document.getElementById('paymentType').value;
            var cardDetails = document.getElementById('cardDetails');
            var upiDetails = document.getElementById('upiDetails');
            
            cardDetails.style.display = 'none';
            upiDetails.style.display = 'none';
            
            if (type === 'Card') {
                cardDetails.style.display = 'block';
                document.getElementById('cardNumber').required = true;
                document.getElementById('cardName').required = true;
                document.getElementById('expiry').required = true;
                document.getElementById('cvv').required = true;
            } else if (type === 'UPI') {
                upiDetails.style.display = 'block';
                document.getElementById('upiId').required = true;
            } else {
                document.getElementById('cardNumber').required = false;
                document.getElementById('cardName').required = false;
                document.getElementById('expiry').required = false;
                document.getElementById('cvv').required = false;
                document.getElementById('upiId').required = false;
            }
        }
        
        function validateForm() {
            var studentId = document.getElementById('studentId').value;
            var paymentType = document.getElementById('paymentType').value;
            var amount = document.getElementById('amount').value;
            var paymentDate = document.getElementById('paymentDate').value;
            
            if (!studentId) {
                alert('Please select a student');
                return false;
            }
            if (!paymentType) {
                alert('Please select payment type');
                return false;
            }
            if (!amount || amount <= 0) {
                alert('Please enter valid amount');
                return false;
            }
            if (!paymentDate) {
                alert('Please select payment date');
                return false;
            }
            
            if (paymentType === 'Card') {
                var cardNumber = document.getElementById('cardNumber').value;
                if (!cardNumber || cardNumber.replace(/\s/g, '').length < 16) {
                    alert('Please enter valid 16-digit card number');
                    return false;
                }
            }
            
            if (paymentType === 'UPI') {
                var upiId = document.getElementById('upiId').value;
                if (!upiId || !upiId.includes('@')) {
                    alert('Please enter valid UPI ID (e.g., name@okhdfcbank)');
                    return false;
                }
            }
            
            return confirm('Confirm payment of ₹' + amount + ' for this student?');
        }
        
        function updateStudentInfo() {
            var select = document.getElementById('studentId');
            var studentName = select.options[select.selectedIndex].text;
            document.getElementById('selectedStudent').innerHTML = studentName;
        }
        
        function formatCardNumber(input) {
            var value = input.value.replace(/\D/g, '');
            if (value.length > 16) value = value.slice(0, 16);
            var formatted = '';
            for (var i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) formatted += ' ';
                formatted += value[i];
            }
            input.value = formatted;
        }
        
        function formatExpiry(input) {
            var value = input.value.replace(/\D/g, '');
            if (value.length >= 2) {
                input.value = value.slice(0, 2) + '/' + value.slice(2, 4);
            } else {
                input.value = value;
            }
        }
        
        function setTodayDate() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('paymentDate').value = today;
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
        <a href="PaymentServlet" class="active">Payments</a>
        <a href="GuardianServlet">Guardians</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="page-header">
        <h1>💵 Add New Payment</h1>
        <a href="PaymentServlet" class="btn btn-secondary">← Back to Payments</a>
    </div>
    
    <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div class="success-msg">✅ <%= successMsg %></div>
    <% } %>
    
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="error-msg">❌ <%= errorMsg %></div>
    <% } %>
    
    <div class="card">
        <form method="post" action="PaymentServlet" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="add">
            
            <div class="form-group">
                <label>Select Student *</label>
                <select name="stId" id="studentId" required onchange="updateStudentInfo()">
                    <option value="">-- Select Student --</option>
                    <% if (students != null && !students.isEmpty()) {
                        for (Student s : students) { %>
                            <option value="<%= s.getStId() %>">
                                <%= s.getName() %> (ID: <%= s.getStId() %>)
                            </option>
                    <%   }
                       } %>
                </select>
            </div>
            
            <div class="payment-summary">
                <h3>📋 Payment Summary</h3>
                <p><strong>Selected Student:</strong> <span id="selectedStudent">-</span></p>
                <p><strong>Fee Amount:</strong> <span class="fee-amount">₹25,000</span> (Annual Tuition Fee)</p>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Payment Amount *</label>
                    <input type="number" name="amount" id="amount" required 
                           value="25000" step="100" min="100">
                </div>
                <div class="form-group">
                    <label>Payment Type *</label>
                    <select name="paymentType" id="paymentType" required onchange="showPaymentDetails()">
                        <option value="">-- Select Payment Method --</option>
                        <option value="Cash">💵 Cash</option>
                        <option value="Card">💳 Credit/Debit Card</option>
                        <option value="UPI">📱 UPI</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label>Payment Date *</label>
                <input type="date" name="paymentDate" id="paymentDate" required value="<%= todayDate %>">
                <div class="date-note">📅 Select the date when payment was received</div>
            </div>
            
            <!-- Card Payment Details -->
            <div id="cardDetails" class="card-details">
                <h4 style="margin-bottom: 15px;">💳 Card Details</h4>
                <div class="form-group">
                    <label>Card Number *</label>
                    <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456" 
                           maxlength="19" oninput="formatCardNumber(this)">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Card Holder Name *</label>
                        <input type="text" id="cardName" placeholder="Name on card">
                    </div>
                    <div class="form-group">
                        <label>Expiry Date *</label>
                        <input type="text" id="expiry" placeholder="MM/YY" maxlength="5" 
                               oninput="formatExpiry(this)">
                    </div>
                    <div class="form-group">
                        <label>CVV *</label>
                        <input type="password" id="cvv" placeholder="123" maxlength="4">
                    </div>
                </div>
            </div>
            
            <!-- UPI Payment Details -->
            <div id="upiDetails" class="upi-details">
                <h4 style="margin-bottom: 15px;">📱 UPI Details</h4>
                <div class="form-group">
                    <label>UPI ID *</label>
                    <input type="text" id="upiId" placeholder="username@okhdfcbank">
                    <div class="date-note">Supported: Google Pay, PhonePe, Paytm, BHIM</div>
                </div>
            </div>
            
            <div class="info-note">
                <strong>ℹ️ Payment Information:</strong>
                <ul style="margin-top: 8px; margin-left: 20px;">
                    <li>Annual tuition fee is ₹25,000 per student</li>
                    <li>Late fee of ₹500 applies after due date (31st March)</li>
                    <li>Payment receipt will be generated after successful payment</li>
                    <li>For card payments, we accept Visa, Mastercard, RuPay</li>
                </ul>
            </div>
            
            <div style="margin-top: 20px; display: flex; gap: 10px;">
                <button type="submit" class="btn btn-primary">💸 Process Payment</button>
                <a href="PaymentServlet" class="btn btn-secondary">Cancel</a>
                <button type="button" class="btn btn-secondary" onclick="setTodayDate()">📅 Today's Date</button>
            </div>
        </form>
    </div>
</main>

</body>
</html>