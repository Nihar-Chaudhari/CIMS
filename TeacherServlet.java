package controller;
import dao.TeacherDAO;
import model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/TeacherServlet")
public class TeacherServlet extends HttpServlet {
    private TeacherDAO dao = new TeacherDAO();
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "admin".equals(s.getAttribute("role"));
    }
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) { response.sendRedirect("login.jsp"); return; }
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                dao.deleteTeacher(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect("TeacherServlet");
            } else {
                request.setAttribute("teachers", dao.getAllTeachers());
                request.getRequestDispatcher("manageTeachers.jsp").forward(request, response);
            }
        } catch (SQLException e) { throw new ServletException(e); }
    }
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) { response.sendRedirect("login.jsp"); return; }
        try {
            Teacher t = new Teacher();
            t.setTName(request.getParameter("tName"));
            t.setAddress(request.getParameter("address"));
            t.setPhone(request.getParameter("phone"));
            t.setSalary(Double.parseDouble(request.getParameter("salary")));
            dao.addTeacher(t);
            response.sendRedirect("TeacherServlet");
        } catch (SQLException e) { throw new ServletException(e); }
    }
}
