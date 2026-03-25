package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import dao.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM Users WHERE Username=? AND Password=?")) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", rs.getString("Username"));
                session.setAttribute("role", rs.getString("Role"));
                
                String role = rs.getString("Role");
                
                // Redirect based on role
                if ("admin".equals(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else if ("teacher".equals(role)) {
                    session.setAttribute("refId", rs.getInt("teacher_id"));
                    response.sendRedirect("teacherDashboard.jsp");
                } else if ("student".equals(role)) {
                    session.setAttribute("refId", rs.getInt("student_id"));
                    response.sendRedirect("studentDashboard.jsp");
                } else if ("guardian".equals(role)) {
                    session.setAttribute("refId", rs.getInt("student_id"));
                    response.sendRedirect("guardianDashboard.jsp");
                }
                
            } else {
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
}