package controller;

import dao.GuardianDAO;
import dao.StudentDAO;
import model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/GuardianServlet")
public class GuardianServlet extends HttpServlet {
    
    private GuardianDAO dao = new GuardianDAO();
    private StudentDAO studentDao = new StudentDAO();
    
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && "admin".equals(session.getAttribute("role"));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        
        try {
            if ("admin".equals(role) && isAdmin(request)) {
                // Admin actions
                if ("edit".equals(action)) {
                    int studentId = Integer.parseInt(request.getParameter("id"));
                    String[] guardian = dao.getGuardianByStudentId(studentId);
                    List<Student> students = studentDao.getAllStudents();
                    
                    request.setAttribute("guardian", guardian);
                    request.setAttribute("studentId", studentId);
                    request.setAttribute("students", students);
                    request.getRequestDispatcher("editGuardian.jsp").forward(request, response);
                    
                } else if ("delete".equals(action)) {
                    int studentId = Integer.parseInt(request.getParameter("id"));
                    dao.deleteGuardian(studentId);
                    response.sendRedirect("GuardianServlet");
                    
                } else {
                    // List all guardians
                    List<String[]> guardians = dao.getAllGuardians();
                    request.setAttribute("guardians", guardians);
                    request.getRequestDispatcher("manageGuardians.jsp").forward(request, response);
                }
                
            } else if ("guardian".equals(role)) {
                // Guardian view
                int studentId = (int) session.getAttribute("refId");
                String studentName = dao.getStudentNameById(studentId);
                List<String[]> payments = dao.getPaymentsByStudent(studentId);
                
                request.setAttribute("studentName", studentName);
                request.setAttribute("payments", payments);
                request.getRequestDispatcher("guardianDashboard.jsp").forward(request, response);
                
            } else {
                response.sendRedirect("login.jsp");
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || !isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                // Add new guardian
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                String name = request.getParameter("name");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                
                dao.addGuardian(studentId, name, phone, email, address, username, password);
                response.sendRedirect("GuardianServlet");
                
            } else if ("update".equals(action)) {
                // Update guardian
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                String name = request.getParameter("name");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                
                dao.updateGuardian(studentId, name, phone, email, address, username, password);
                response.sendRedirect("GuardianServlet");
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
}