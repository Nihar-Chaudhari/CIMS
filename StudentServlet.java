package controller;

import dao.StudentDAO;
import model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    
    private StudentDAO dao = new StudentDAO();
    
    // Check if user is admin
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && "admin".equals(session.getAttribute("role"));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            // Handle delete
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteStudent(id);
                response.sendRedirect("StudentServlet");
            } 
            // Handle edit - show edit form
            else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Student student = dao.getStudentById(id);
                request.setAttribute("student", student);
                request.getRequestDispatcher("editStudent.jsp").forward(request, response);
            } 
            // Default - show all students
            else {
                List<Student> students = dao.getAllStudents();
                request.setAttribute("students", students);
                request.getRequestDispatcher("manageStudents.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        } catch (NumberFormatException e) {
            response.sendRedirect("StudentServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            // Handle update
            if ("update".equals(action)) {
                Student s = new Student();
                s.setStId(Integer.parseInt(request.getParameter("stId")));
                s.setName(request.getParameter("name"));
                s.setDob(request.getParameter("dob"));
                s.setPhone(request.getParameter("phone"));
                s.setAddress(request.getParameter("address"));
                s.setUsername(request.getParameter("username"));
                s.setPassword(request.getParameter("password"));
                
                dao.updateStudent(s);
                response.sendRedirect("StudentServlet");
            } 
            // Handle add
            else {
                Student s = new Student();
                s.setName(request.getParameter("name"));
                s.setDob(request.getParameter("dob"));
                s.setPhone(request.getParameter("phone"));
                s.setAddress(request.getParameter("address"));
                s.setUsername(request.getParameter("username"));
                s.setPassword(request.getParameter("password"));
                
                dao.addStudent(s);
                response.sendRedirect("StudentServlet");
            }
            
        } catch (SQLException e) {
            // Check for duplicate username
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("errorMsg", "Username already exists. Please choose another.");
                request.getRequestDispatcher("addStudent.jsp").forward(request, response);
            } else {
                throw new ServletException("Database error: " + e.getMessage(), e);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("StudentServlet");
        }
    }
}