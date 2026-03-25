package controller;
import dao.ExamDAO;
import model.Exam;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ExamServlet")
public class ExamServlet extends HttpServlet {
    private ExamDAO dao = new ExamDAO();
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
                dao.deleteExam(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect("ExamServlet");
            } else {
                request.setAttribute("exams", dao.getAllExams());
                request.getRequestDispatcher("manageExams.jsp").forward(request, response);
            }
        } catch (SQLException e) { throw new ServletException(e); }
    }
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) { response.sendRedirect("login.jsp"); return; }
        try {
            Exam e = new Exam();
            e.setExamName(request.getParameter("examName"));
            e.setYear(Integer.parseInt(request.getParameter("year")));
            e.setTotalMarks(Integer.parseInt(request.getParameter("totalMarks")));
            e.setEMode(request.getParameter("eMode"));
            e.setExamDate(request.getParameter("examDate"));
            dao.addExam(e);
            response.sendRedirect("ExamServlet");
        } catch (SQLException ex) { throw new ServletException(ex); }
    }
}
