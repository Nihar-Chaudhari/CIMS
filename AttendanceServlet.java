package controller;

import dao.AttendanceDAO;
import model.Attendance;
import model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    
    private AttendanceDAO dao = new AttendanceDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        int refId = (int) session.getAttribute("refId");
        
        try {
            if ("teacher".equals(role)) {
                // Get all necessary data for teacher
                List<Student> students = dao.getStudentsByTeacher(refId);
                List<Map<String, Object>> subjects = dao.getSubjectsByTeacher(refId);
                List<Attendance> attendanceList = dao.getAttendanceByTeacher(refId);
                
                request.setAttribute("students", students);
                request.setAttribute("subjects", subjects);
                request.setAttribute("attendanceList", attendanceList);
                request.getRequestDispatcher("markAttendance.jsp").forward(request, response);
                
            } else if ("student".equals(role)) {
                List<Attendance> attendanceList = dao.getAttendanceByStudent(refId);
                request.setAttribute("attendanceList", attendanceList);
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
        
        String action = request.getParameter("action");
        int teacherId = (int) session.getAttribute("refId");
        
        try {
            if ("markMultiple".equals(action)) {
                // Batch attendance marking
                String[] presentIds = request.getParameterValues("presentIds");
                int sId = Integer.parseInt(request.getParameter("sId"));
                String attDate = request.getParameter("attDate");
                
                List<Student> students = dao.getStudentsByTeacher(teacherId);
                int markedCount = 0;
                
                for (Student student : students) {
                    String status = "Absent";
                    if (presentIds != null) {
                        for (String id : presentIds) {
                            if (Integer.parseInt(id) == student.getStId()) {
                                status = "Present";
                                break;
                            }
                        }
                    }
                    
                    Attendance a = new Attendance();
                    a.setStId(student.getStId());
                    a.setTId(teacherId);
                    a.setSId(sId);
                    a.setAttDate(attDate);
                    a.setStatus(status);
                    
                    dao.markAttendance(a);
                    markedCount++;
                }
                
                request.setAttribute("successMsg", "Attendance marked for " + markedCount + " students!");
                
            } else {
                // Single student attendance
                int stId = Integer.parseInt(request.getParameter("stId"));
                int sId = Integer.parseInt(request.getParameter("sId"));
                String attDate = request.getParameter("attDate");
                String status = request.getParameter("status");
                
                Attendance a = new Attendance();
                a.setStId(stId);
                a.setTId(teacherId);
                a.setSId(sId);
                a.setAttDate(attDate);
                a.setStatus(status);
                
                dao.markAttendance(a);
                request.setAttribute("successMsg", "Attendance marked for Student ID: " + stId);
            }
            
            // Refresh data
            List<Student> students = dao.getStudentsByTeacher(teacherId);
            List<Map<String, Object>> subjects = dao.getSubjectsByTeacher(teacherId);
            List<Attendance> attendanceList = dao.getAttendanceByTeacher(teacherId);
            
            request.setAttribute("students", students);
            request.setAttribute("subjects", subjects);
            request.setAttribute("attendanceList", attendanceList);
            request.getRequestDispatcher("markAttendance.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Invalid input: " + e.getMessage());
            try {
                List<Student> students = dao.getStudentsByTeacher(teacherId);
                List<Map<String, Object>> subjects = dao.getSubjectsByTeacher(teacherId);
                List<Attendance> attendanceList = dao.getAttendanceByTeacher(teacherId);
                request.setAttribute("students", students);
                request.setAttribute("subjects", subjects);
                request.setAttribute("attendanceList", attendanceList);
                request.getRequestDispatcher("markAttendance.jsp").forward(request, response);
            } catch (SQLException ex) {
                throw new ServletException(ex);
            }
        }
    }
}