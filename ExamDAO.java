package dao;
import model.Exam;
import java.sql.*;
import java.util.*;

public class ExamDAO {
    public List<Exam> getAllExams() throws SQLException {
        List<Exam> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM Exams")) {
            while (rs.next())
                list.add(new Exam(rs.getInt("E_ID"), rs.getString("Exam_Name"),
                    rs.getInt("Year"), rs.getInt("Total_Marks"), rs.getString("E_Mode")));
        }
        return list;
    }
    public void addExam(Exam e) throws SQLException {
        String sql = "INSERT INTO Exams (Exam_Name,Year,Total_Marks,E_Mode,Exam_Date) VALUES (?,?,?,?,?)";


        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, e.getExamName()); ps.setInt(2, e.getYear());
            ps.setInt(3, e.getTotalMarks()); ps.setString(4, e.getEMode());
            ps.setString(5, e.getExamDate());
            ps.executeUpdate();
        }
    }
    public void deleteExam(int id) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM Exams WHERE E_ID=?")) {
            ps.setInt(1, id); ps.executeUpdate();
        }
    }
    public int countExams() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             ResultSet rs = con.createStatement().executeQuery(
                 "SELECT COUNT(*) c FROM Exams")) {
            return rs.next() ? rs.getInt("c") : 0;
        }
    }
}
