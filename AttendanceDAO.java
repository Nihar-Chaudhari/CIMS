package dao;

import model.Attendance;
import model.Student;
import java.sql.*;
import java.util.*;

public class AttendanceDAO {

    // Mark single attendance
    public void markAttendance(Attendance a) throws SQLException {
        String sql = "INSERT INTO Attendance (ST_ID, T_ID, S_ID, Att_Date, Status) VALUES (?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, a.getStId());
            ps.setInt(2, a.getTId());
            ps.setInt(3, a.getSId());
            ps.setString(4, a.getAttDate());
            ps.setString(5, a.getStatus());
            ps.executeUpdate();
        }
    }

    // Get students assigned to a teacher
    public List<Student> getStudentsByTeacher(int teacherId) throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT DISTINCT s.ST_ID, s.Name, s.DOB, s.Phone, s.Address " +
                     "FROM Students s " +
                     "JOIN Reads_In ri ON s.ST_ID = ri.ST_ID " +
                     "JOIN Assigned_To at ON ri.C_ID = at.C_ID " +
                     "WHERE at.T_ID = ? " +
                     "ORDER BY s.Name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setStId(rs.getInt("ST_ID"));
                s.setName(rs.getString("Name"));
                s.setDob(rs.getString("DOB"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                students.add(s);
            }
        }
        return students;
    }

    // Get subjects taught by a teacher
    public List<Map<String, Object>> getSubjectsByTeacher(int teacherId) throws SQLException {
        List<Map<String, Object>> subjects = new ArrayList<>();
        String sql = "SELECT s.S_ID, s.S_Name, c.C_Name " +
                     "FROM Subject s " +
                     "JOIN Class c ON s.Class_ID = c.C_ID " +
                     "JOIN Teaches t ON s.S_ID = t.S_ID " +
                     "WHERE t.T_ID = ? " +
                     "ORDER BY s.S_Name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> subject = new HashMap<>();
                subject.put("sId", rs.getInt("S_ID"));
                subject.put("sName", rs.getString("S_Name"));
                subject.put("className", rs.getString("C_Name"));
                subjects.add(subject);
            }
        }
        return subjects;
    }

    // Get attendance records by teacher
    public List<Attendance> getAttendanceByTeacher(int teacherId) throws SQLException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.* FROM Attendance a " +
                     "WHERE a.T_ID = ? " +
                     "ORDER BY a.Att_Date DESC, a.A_ID DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAId(rs.getInt("A_ID"));
                a.setStId(rs.getInt("ST_ID"));
                a.setTId(rs.getInt("T_ID"));
                a.setSId(rs.getInt("S_ID"));
                a.setAttDate(rs.getString("Att_Date"));
                a.setStatus(rs.getString("Status"));
                list.add(a);
            }
        }
        return list;
    }

    // Get attendance records by student
    public List<Attendance> getAttendanceByStudent(int studentId) throws SQLException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM Attendance WHERE ST_ID=? ORDER BY Att_Date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setAId(rs.getInt("A_ID"));
                a.setStId(rs.getInt("ST_ID"));
                a.setTId(rs.getInt("T_ID"));
                a.setSId(rs.getInt("S_ID"));
                a.setAttDate(rs.getString("Att_Date"));
                a.setStatus(rs.getString("Status"));
                list.add(a);
            }
        }
        return list;
    }

    public int countAttendanceByStudent(int stId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Attendance WHERE ST_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, stId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}