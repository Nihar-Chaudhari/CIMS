package controller;

import dao.PaymentDAO;
import dao.StudentDAO;
import model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    
    private PaymentDAO paymentDAO = new PaymentDAO();
    private StudentDAO studentDAO = new StudentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        
        try {
            // Handle Admin requests
            if ("admin".equals(role)) {
                
                // Add Payment Form
                if ("add".equals(action)) {
                    List<Student> students = studentDAO.getAllStudents();
                    request.setAttribute("students", students);
                    request.getRequestDispatcher("addPayment.jsp").forward(request, response);
                } 
                // Delete Payment
                else if ("delete".equals(action)) {
                    int paymentId = Integer.parseInt(request.getParameter("id"));
                    paymentDAO.deletePayment(paymentId);
                    response.sendRedirect("PaymentServlet");
                } 
                // View All Payments
                else {
                    List<String[]> payments = paymentDAO.getAllPayments();
                    request.setAttribute("payments", payments);
                    request.getRequestDispatcher("managePayments.jsp").forward(request, response);
                }
            } 
            // Handle Guardian requests
            else if ("guardian".equals(role)) {
                int studentId = (int) session.getAttribute("refId");
                String studentName = studentDAO.getStudentNameById(studentId);
                List<String[]> payments = paymentDAO.getPaymentsByStudent(studentId);
                
                request.setAttribute("studentName", studentName);
                request.setAttribute("payments", payments);
                request.getRequestDispatcher("guardianDashboard.jsp").forward(request, response);
            } 
            // Redirect to login for other roles
            else {
                response.sendRedirect("login.jsp");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage(), e);
        } catch (NumberFormatException e) {
            response.sendRedirect("PaymentServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        
        try {
            // Get common payment details
            int studentId = Integer.parseInt(request.getParameter("stId"));
            String paymentType = request.getParameter("paymentType");
            String amountStr = request.getParameter("amount");
            String paymentDate = request.getParameter("paymentDate");
            String details = "";
            
            // Collect payment details based on payment type
            if ("Card".equals(paymentType)) {
                String cardNumber = request.getParameter("cardNumber");
                String cardName = request.getParameter("cardName");
                String expiry = request.getParameter("expiry");
                details = "Card: " + cardNumber + " | Holder: " + cardName + " | Exp: " + expiry;
            } else if ("UPI".equals(paymentType)) {
                details = request.getParameter("upiId");
            } else if ("Cash".equals(paymentType)) {
                details = "Cash Payment";
            }
            
            // Parse amount (default 25000 if not provided)
            double amount = 25000;
            if (amountStr != null && !amountStr.isEmpty()) {
                amount = Double.parseDouble(amountStr);
            }
            
            // Add payment to database
            paymentDAO.addPayment(studentId, paymentType, amount, details, paymentDate);
            
            // Handle response based on role
            if ("admin".equals(role)) {
                request.setAttribute("successMsg", "Payment of ₹" + amount + " added successfully!");
                List<Student> students = studentDAO.getAllStudents();
                request.setAttribute("students", students);
                request.getRequestDispatcher("addPayment.jsp").forward(request, response);
            } else {
                request.setAttribute("successMsg", "Payment successful! ₹" + amount + " paid.");
                String studentName = studentDAO.getStudentNameById(studentId);
                List<String[]> payments = paymentDAO.getPaymentsByStudent(studentId);
                request.setAttribute("studentName", studentName);
                request.setAttribute("payments", payments);
                request.getRequestDispatcher("guardianDashboard.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage(), e);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid input: " + e.getMessage(), e);
        }
    }
}