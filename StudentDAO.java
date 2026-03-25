package dao;

import model.Student;
import java.sql.*;
import java.util.*;

public class StudentDAO {

    // Get all students with their login credentials
    public List<Student> getAllStudents() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.ST_ID, s.Name, s.DOB, s.Phone, s.Address, " +
                     "u.Username, u.Password " +
                     "FROM Students s " +
                     "LEFT JOIN Users u ON u.student_id = s.ST_ID AND u.Role = 'student' " +
                     "ORDER BY s.ST_ID DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Student s = new Student();
                s.setStId(rs.getInt("ST_ID"));
                s.setName(rs.getString("Name"));
                s.setDob(rs.getString("DOB"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setUsername(rs.getString("Username"));
                s.setPassword(rs.getString("Password"));
                list.add(s);
            }
        }
        return list;
    }

    // Add new student with login credentials
    public void addStudent(Student s) throws SQLException {
        Connection con = null;
        PreparedStatement psStudent = null;
        PreparedStatement psUser = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Insert into Students table
            String sqlStudent = "INSERT INTO Students (Name, DOB, Phone, Address) VALUES (?,?,?,?)";
            psStudent = con.prepareStatement(sqlStudent, Statement.RETURN_GENERATED_KEYS);
            psStudent.setString(1, s.getName());
            psStudent.setString(2, s.getDob());
            psStudent.setString(3, s.getPhone());
            psStudent.setString(4, s.getAddress());
            psStudent.executeUpdate();
            
            // Get generated student ID
            ResultSet rs = psStudent.getGeneratedKeys();
            int studentId = 0;
            if (rs.next()) {
                studentId = rs.getInt(1);
            }
            
            // Insert into Users table with student_id
            String sqlUser = "INSERT INTO Users (Username, Password, Role, student_id) VALUES (?,?,?,?)";
            psUser = con.prepareStatement(sqlUser);
            psUser.setString(1, s.getUsername());
            psUser.setString(2, s.getPassword());
            psUser.setString(3, "student");
            psUser.setInt(4, studentId);
            psUser.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psStudent != null) try { psStudent.close(); } catch (SQLException e) {}
            if (psUser != null) try { psUser.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Update student with login credentials
    public void updateStudent(Student s) throws SQLException {
        Connection con = null;
        PreparedStatement psStudent = null;
        PreparedStatement psUser = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Update Students table
            String sqlStudent = "UPDATE Students SET Name=?, DOB=?, Phone=?, Address=? WHERE ST_ID=?";
            psStudent = con.prepareStatement(sqlStudent);
            psStudent.setString(1, s.getName());
            psStudent.setString(2, s.getDob());
            psStudent.setString(3, s.getPhone());
            psStudent.setString(4, s.getAddress());
            psStudent.setInt(5, s.getStId());
            psStudent.executeUpdate();
            
            // Check if user exists in Users table
            String checkUser = "SELECT COUNT(*) FROM Users WHERE student_id=? AND Role='student'";
            PreparedStatement psCheck = con.prepareStatement(checkUser);
            psCheck.setInt(1, s.getStId());
            ResultSet rs = psCheck.executeQuery();
            boolean userExists = rs.next() && rs.getInt(1) > 0;
            
            if (userExists) {
                // Update existing user
                String sqlUser = "UPDATE Users SET Username=?, Password=? WHERE student_id=? AND Role='student'";
                psUser = con.prepareStatement(sqlUser);
                psUser.setString(1, s.getUsername());
                psUser.setString(2, s.getPassword());
                psUser.setInt(3, s.getStId());
                psUser.executeUpdate();
            } else {
                // Insert new user
                String sqlUser = "INSERT INTO Users (Username, Password, Role, student_id) VALUES (?,?,?,?)";
                psUser = con.prepareStatement(sqlUser);
                psUser.setString(1, s.getUsername());
                psUser.setString(2, s.getPassword());
                psUser.setString(3, "student");
                psUser.setInt(4, s.getStId());
                psUser.executeUpdate();
            }
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psStudent != null) try { psStudent.close(); } catch (SQLException e) {}
            if (psUser != null) try { psUser.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Delete student and their login credentials
    public void deleteStudent(int id) throws SQLException {
        Connection con = null;
        PreparedStatement psDeleteUser = null;
        PreparedStatement psDeleteStudent = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Delete from Users table first
            String sqlDeleteUser = "DELETE FROM Users WHERE student_id = ? AND Role = 'student'";
            psDeleteUser = con.prepareStatement(sqlDeleteUser);
            psDeleteUser.setInt(1, id);
            psDeleteUser.executeUpdate();
            
            // Then delete from Students table
            String sqlDeleteStudent = "DELETE FROM Students WHERE ST_ID=?";
            psDeleteStudent = con.prepareStatement(sqlDeleteStudent);
            psDeleteStudent.setInt(1, id);
            psDeleteStudent.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psDeleteUser != null) try { psDeleteUser.close(); } catch (SQLException e) {}
            if (psDeleteStudent != null) try { psDeleteStudent.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Get student by ID
    public Student getStudentById(int id) throws SQLException {
        String sql = "SELECT s.ST_ID, s.Name, s.DOB, s.Phone, s.Address, " +
                     "u.Username, u.Password " +
                     "FROM Students s " +
                     "LEFT JOIN Users u ON u.student_id = s.ST_ID AND u.Role = 'student' " +
                     "WHERE s.ST_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Student s = new Student();
                s.setStId(rs.getInt("ST_ID"));
                s.setName(rs.getString("Name"));
                s.setDob(rs.getString("DOB"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setUsername(rs.getString("Username"));
                s.setPassword(rs.getString("Password"));
                return s;
            }
        }
        return null;
    }

    public int countStudents() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) c FROM Students")) {
            return rs.next() ? rs.getInt("c") : 0;
        }
    }
    // Get student name by ID
public String getStudentNameById(int studentId) throws SQLException {
    String sql = "SELECT Name FROM Students WHERE ST_ID = ?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("Name");
        }
    }
    return null;
}
}