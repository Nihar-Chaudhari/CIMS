<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("role") == null || !"guardian".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<String[]> payments = (List<String[]>) request.getAttribute("payments");
    String studentName = (String) request.getAttribute("studentName");
    int studentId = (int) session.getAttribute("refId");
    String successMsg = (String) request.getAttribute("successMsg");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guardian Dashboard - CIMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .welcome-banner {
            background: linear-gradient(135deg, #2c5282 0%, #2a7abf 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
        }
        .student-card {
            background: linear-gradient(135deg, #f0f4f8 0%, #e6fffa 100%);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border-left: 4px solid #2a7abf;
        }
        .payment-form {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
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
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }
        .btn-primary {
            background: #2a7abf;
            color: white;
        }
        .btn-primary:hover {
            background: #1e5a8f;
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
        .badge {
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success {
            background: #c6f6d5;
            color: #22543d;
        }
        .payment-type {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .type-cash { background: #e6fffa; color: #276749; }
        .type-card { background: #ebf8ff; color: #2c5282; }
        .type-upi { background: #fef5e7; color: #dd6b20; }
    </style>
    <script>
        function showPaymentDetails() {
            var type = document.getElementById('paymentType').value;
            var detailsDiv = document.getElementById('paymentDetails');
            var detailsLabel = document.getElementById('detailsLabel');
            var detailsInput = document.getElementById('details');
            
            if (type === 'Card') {
                detailsDiv.style.display = 'block';
                detailsLabel.textContent = 'Card Number *';
                detailsInput.placeholder = 'Enter 16-digit card number';
                detailsInput.required = true;
            } else if (type === 'UPI') {
                detailsDiv.style.display = 'block';
                detailsLabel.textContent = 'UPI ID *';
                detailsInput.placeholder = 'Enter UPI ID (e.g., name@okhdfcbank)';
                detailsInput.required = true;
            } else {
                detailsDiv.style.display = 'none';
                detailsInput.required = false;
            }
        }
        
        function validatePaymentForm() {
            var paymentType = document.getElementById('paymentType').value;
            var details = document.getElementById('details').value;
            
            if (!paymentType) {
                alert('Please select payment method');
                return false;
            }
            
            if (paymentType === 'Card') {
                if (!details || details.length < 16) {
                    alert('Please enter a valid 16-digit card number');
                    return false;
                }
            }
            if (paymentType === 'UPI') {
                if (!details || !details.includes('@')) {
                    alert('Please enter a valid UPI ID');
                    return false;
                }
            }
            
            return confirm('Confirm payment of ₹25,000?');
        }
    </script>
</head>
<body>

<header class="navbar">
    <a class="brand" href="guardianDashboard.jsp">🏫 CIMS</a>
    <nav>
        <a href="guardianDashboard.jsp" class="active">Dashboard</a>
        <a href="PaymentServlet">Payments</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">
    <div class="welcome-banner">
        <h1>👨‍👩‍👧 Welcome, <%= session.getAttribute("username") %>!</h1>
        <p>Manage your ward's academic and fee details from one place.</p>
    </div>
    
    <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div class="success-msg">✅ <%= successMsg %></div>
    <% } %>
    
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="error-msg">❌ <%= errorMsg %></div>
    <% } %>
    
    <div class="student-card">
        <h3>📚 Ward Information</h3>
        <p><strong>Student ID:</strong> <%= studentId %></p>
        <p><strong>Student Name:</strong> <%= studentName != null ? studentName : "Loading..." %></p>
        <p><strong>Class:</strong> Class 10 - Science</p>
        <p><strong>Status:</strong> <span class="badge badge-success">Active</span></p>
    </div>
    
    <!-- Payment Form -->
    <div class="payment-form">
        <h3 style="margin-bottom: 15px;">💰 Pay Fees</h3>
        <form method="post" action="PaymentServlet" onsubmit="return validatePaymentForm()">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="stId" value="<%= studentId %>">
            <input type="hidden" name="amount" value="25000">
            
            <div class="form-group">
                <label>Payment Amount</label>
                <input type="text" value="₹25,000 (Annual Tuition Fee)" readonly disabled 
                       style="background: #f0f4f8;">
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
            
            <div id="paymentDetails" style="display: none;">
                <div class="form-group">
                    <label id="detailsLabel">Details</label>
                    <input type="text" name="details" id="details" placeholder="Enter details">
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary">💸 Pay Now</button>
        </form>
    </div>
    
    <!-- Payment History -->
    <div class="card">
        <h3 style="margin-bottom: 15px;">📋 Payment History</h3>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Payment Type</th>
                        <th>Amount</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (payments != null && !payments.isEmpty()) { 
                        for (String[] p : payments) { %>
                        <tr>
                            <td>#<%= p[0] %></td>
                            <td>
                                <span class="payment-type type-<%= p[1].toLowerCase() %>">
                                    <% if ("Cash".equals(p[1])) { %>
                                        💵 Cash
                                    <% } else if ("Card".equals(p[1])) { %>
                                        💳 Card
                                    <% } else if ("UPI".equals(p[1])) { %>
                                        📱 UPI
                                    <% } %>
                                </span>
                            </td>
                            <td>₹25,000</td>
                            <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date()) %></td>
                            <td><span class="badge badge-success">Completed</span></td>
                        </tr>
                    <% } 
                    } else { %>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px;">
                                No payment records found.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <div class="card">
        <h3 style="margin-bottom: 15px;">ℹ️ Fee Information</h3>
        <ul style="margin-left: 1.5rem; color: #4a5568;">
            <li>Annual Tuition Fee: ₹25,000</li>
            <li>Exam Fee: ₹2,500 per exam</li>
            <li>Late Fee: ₹500 (if paid after due date)</li>
            <li>Due Date: 31st March 2024</li>
            <li>Payment can be made via Cash, Card, or UPI</li>
        </ul>
    </div>
</main>

</body>
</html>