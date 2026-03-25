package dao;

import model.Teacher;
import java.sql.*;
import java.util.*;

public class TeacherDAO {

    // Get all teachers with their login credentials
    public List<Teacher> getAllTeachers() throws SQLException {
        List<Teacher> list = new ArrayList<>();
        String sql = "SELECT t.T_ID, t.T_Name, t.Address, t.Phone, t.Salary, " +
                     "u.Username, u.Password " +
                     "FROM Teachers t " +
                     "LEFT JOIN Users u ON u.teacher_id = t.T_ID AND u.Role = 'teacher' " +
                     "ORDER BY t.T_ID DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Teacher t = new Teacher();
                t.setTId(rs.getInt("T_ID"));
                t.setTName(rs.getString("T_Name"));
                t.setAddress(rs.getString("Address"));
                t.setPhone(rs.getString("Phone"));
                t.setSalary(rs.getDouble("Salary"));
                t.setUsername(rs.getString("Username"));
                t.setPassword(rs.getString("Password"));
                list.add(t);
            }
        }
        return list;
    }

    // Add new teacher with login credentials
    public void addTeacher(Teacher t) throws SQLException {
        Connection con = null;
        PreparedStatement psTeacher = null;
        PreparedStatement psUser = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Insert into Teachers table
            String sqlTeacher = "INSERT INTO Teachers (T_Name, Address, Phone, Salary) VALUES (?,?,?,?)";
            psTeacher = con.prepareStatement(sqlTeacher, Statement.RETURN_GENERATED_KEYS);
            psTeacher.setString(1, t.getTName());
            psTeacher.setString(2, t.getAddress());
            psTeacher.setString(3, t.getPhone());
            psTeacher.setDouble(4, t.getSalary());
            psTeacher.executeUpdate();
            
            // Get generated teacher ID
            ResultSet rs = psTeacher.getGeneratedKeys();
            int teacherId = 0;
            if (rs.next()) {
                teacherId = rs.getInt(1);
            }
            
            // Insert into Users table with teacher_id
            String sqlUser = "INSERT INTO Users (Username, Password, Role, teacher_id) VALUES (?,?,?,?)";
            psUser = con.prepareStatement(sqlUser);
            psUser.setString(1, t.getUsername());
            psUser.setString(2, t.getPassword());
            psUser.setString(3, "teacher");
            psUser.setInt(4, teacherId);
            psUser.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psTeacher != null) try { psTeacher.close(); } catch (SQLException e) {}
            if (psUser != null) try { psUser.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Update teacher with login credentials
    public void updateTeacher(Teacher t) throws SQLException {
        Connection con = null;
        PreparedStatement psTeacher = null;
        PreparedStatement psUser = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Update Teachers table
            String sqlTeacher = "UPDATE Teachers SET T_Name=?, Address=?, Phone=?, Salary=? WHERE T_ID=?";
            psTeacher = con.prepareStatement(sqlTeacher);
            psTeacher.setString(1, t.getTName());
            psTeacher.setString(2, t.getAddress());
            psTeacher.setString(3, t.getPhone());
            psTeacher.setDouble(4, t.getSalary());
            psTeacher.setInt(5, t.getTId());
            psTeacher.executeUpdate();
            
            // Check if user exists
            String checkUser = "SELECT COUNT(*) FROM Users WHERE teacher_id=? AND Role='teacher'";
            PreparedStatement psCheck = con.prepareStatement(checkUser);
            psCheck.setInt(1, t.getTId());
            ResultSet rs = psCheck.executeQuery();
            boolean userExists = rs.next() && rs.getInt(1) > 0;
            
            if (userExists) {
                // Update existing user
                String sqlUser = "UPDATE Users SET Username=?, Password=? WHERE teacher_id=? AND Role='teacher'";
                psUser = con.prepareStatement(sqlUser);
                psUser.setString(1, t.getUsername());
                psUser.setString(2, t.getPassword());
                psUser.setInt(3, t.getTId());
                psUser.executeUpdate();
            } else {
                // Insert new user
                String sqlUser = "INSERT INTO Users (Username, Password, Role, teacher_id) VALUES (?,?,?,?)";
                psUser = con.prepareStatement(sqlUser);
                psUser.setString(1, t.getUsername());
                psUser.setString(2, t.getPassword());
                psUser.setString(3, "teacher");
                psUser.setInt(4, t.getTId());
                psUser.executeUpdate();
            }
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psTeacher != null) try { psTeacher.close(); } catch (SQLException e) {}
            if (psUser != null) try { psUser.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Delete teacher and their login credentials
    public void deleteTeacher(int id) throws SQLException {
        Connection con = null;
        PreparedStatement psDeleteUser = null;
        PreparedStatement psDeleteTeacher = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Delete from Users table first
            String sqlDeleteUser = "DELETE FROM Users WHERE teacher_id = ? AND Role = 'teacher'";
            psDeleteUser = con.prepareStatement(sqlDeleteUser);
            psDeleteUser.setInt(1, id);
            psDeleteUser.executeUpdate();
            
            // Then delete from Teachers table
            String sqlDeleteTeacher = "DELETE FROM Teachers WHERE T_ID=?";
            psDeleteTeacher = con.prepareStatement(sqlDeleteTeacher);
            psDeleteTeacher.setInt(1, id);
            psDeleteTeacher.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psDeleteUser != null) try { psDeleteUser.close(); } catch (SQLException e) {}
            if (psDeleteTeacher != null) try { psDeleteTeacher.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }

    // Get teacher by ID
    public Teacher getTeacherById(int id) throws SQLException {
        String sql = "SELECT t.T_ID, t.T_Name, t.Address, t.Phone, t.Salary, " +
                     "u.Username, u.Password " +
                     "FROM Teachers t " +
                     "LEFT JOIN Users u ON u.teacher_id = t.T_ID AND u.Role = 'teacher' " +
                     "WHERE t.T_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Teacher t = new Teacher();
                t.setTId(rs.getInt("T_ID"));
                t.setTName(rs.getString("T_Name"));
                t.setAddress(rs.getString("Address"));
                t.setPhone(rs.getString("Phone"));
                t.setSalary(rs.getDouble("Salary"));
                t.setUsername(rs.getString("Username"));
                t.setPassword(rs.getString("Password"));
                return t;
            }
        }
        return null;
    }

    public int countTeachers() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) c FROM Teachers")) {
            return rs.next() ? rs.getInt("c") : 0;
        }
    }
}