package controller;

import dao.MaterialDAO;
import model.Material;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/MaterialServlet")
public class MaterialServlet extends HttpServlet {
    
    private MaterialDAO dao = new MaterialDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        
        try {
            // Always get all materials for display
            request.setAttribute("materials", dao.getAllMaterial());
            
            if ("teacher".equals(role)) {
                // Teacher view - show upload form and materials
                request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);
            } else if ("student".equals(role)) {
                // Student view - forward to student dashboard with materials
                request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
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
        
        if (session == null || !"teacher".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            Material m = new Material();
            m.setTId((int) session.getAttribute("refId"));
            m.setSId(Integer.parseInt(request.getParameter("sId")));
            m.setTitle(request.getParameter("title"));
            m.setDescription(request.getParameter("description"));
            m.setFileLink(request.getParameter("fileLink"));
            m.setUploadDate(LocalDate.now().toString());
            
            dao.addMaterial(m);
            response.sendRedirect("MaterialServlet");
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid input format: " + e.getMessage(), e);
        }
    }
}