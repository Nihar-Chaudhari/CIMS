package dao;

import java.sql.*;
import java.util.*;

public class GuardianDAO {
    
    // ==================== GUARDIAN MANAGEMENT ====================
    
    // Get all guardians with their details
    public List<String[]> getAllGuardians() throws SQLException {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT g.ST_ID, g.Name, s.Name as StudentName, g.Phone, g.Email, g.Address, " +
                     "u.Username, u.Password " +
                     "FROM Guardian g " +
                     "JOIN Students s ON g.ST_ID = s.ST_ID " +
                     "LEFT JOIN Users u ON u.student_id = g.ST_ID AND u.Role = 'guardian' " +
                     "ORDER BY g.ST_ID DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                String[] guardian = new String[8];
                guardian[0] = rs.getString("ST_ID");
                guardian[1] = rs.getString("Name");
                guardian[2] = rs.getString("StudentName");
                guardian[3] = rs.getString("Phone");
                guardian[4] = rs.getString("Email");
                guardian[5] = rs.getString("Username");
                guardian[6] = rs.getString("Password");
                guardian[7] = rs.getString("Address");
                list.add(guardian);
            }
        }
        return list;
    }
    
    // Add new guardian
    public void addGuardian(int studentId, String name, String phone, String email, 
                            String address, String username, String password) throws SQLException {
        Connection con = null;
        PreparedStatement psGuardian = null;
        PreparedStatement psUser = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Check if guardian already exists
            String checkSql = "SELECT COUNT(*) FROM Guardian WHERE ST_ID = ?";
            PreparedStatement psCheck = con.prepareStatement(checkSql);
            psCheck.setInt(1, studentId);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new SQLException("Guardian already exists for this student");
            }
            
            // Insert into Guardian table
            String sqlGuardian = "INSERT INTO Guardian (ST_ID, Name, Phone, Email, Address) VALUES (?,?,?,?,?)";
            psGuardian = con.prepareStatement(sqlGuardian);
            psGuardian.setInt(1, studentId);
            psGuardian.setString(2, name);
            psGuardian.setString(3, phone);
            psGuardian.setString(4, email);
            psGuardian.setString(5, address);
            psGuardian.executeUpdate();
            
            // Insert into Users table
            String sqlUser = "INSERT INTO Users (Username, Password, Role, student_id) VALUES (?,?,?,?)";
            psUser = con.prepareStatement(sqlUser);
            psUser.setString(1, username);
            psUser.setString(2, password);
            psUser.setString(3, "guardian");
            psUser.setInt(4, studentId);
            psUser.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psGuardian != null) try { psGuardian.close(); } catch (SQLException e) {}
            if (psUser != null) try { psUser.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
    
    // Update guardian
    public void updateGuardian(int studentId, String name, String phone, String email, 
                               String address, String username, String password) throws SQLException {
        Connection con = null;
        PreparedStatement psGuardian = null;
        PreparedStatement psUser = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Update Guardian table
            String sqlGuardian = "UPDATE Guardian SET Name=?, Phone=?, Email=?, Address=? WHERE ST_ID=?";
            psGuardian = con.prepareStatement(sqlGuardian);
            psGuardian.setString(1, name);
            psGuardian.setString(2, phone);
            psGuardian.setString(3, email);
            psGuardian.setString(4, address);
            psGuardian.setInt(5, studentId);
            psGuardian.executeUpdate();
            
            // Update Users table
            String sqlUser = "UPDATE Users SET Username=?, Password=? WHERE student_id=? AND Role='guardian'";
            psUser = con.prepareStatement(sqlUser);
            psUser.setString(1, username);
            psUser.setString(2, password);
            psUser.setInt(3, studentId);
            psUser.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psGuardian != null) try { psGuardian.close(); } catch (SQLException e) {}
            if (psUser != null) try { psUser.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
    
    // Delete guardian
    public void deleteGuardian(int studentId) throws SQLException {
        Connection con = null;
        PreparedStatement psDeleteUser = null;
        PreparedStatement psDeleteGuardian = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Delete from Users table first
            String sqlDeleteUser = "DELETE FROM Users WHERE student_id = ? AND Role = 'guardian'";
            psDeleteUser = con.prepareStatement(sqlDeleteUser);
            psDeleteUser.setInt(1, studentId);
            psDeleteUser.executeUpdate();
            
            // Delete from Guardian table
            String sqlDeleteGuardian = "DELETE FROM Guardian WHERE ST_ID = ?";
            psDeleteGuardian = con.prepareStatement(sqlDeleteGuardian);
            psDeleteGuardian.setInt(1, studentId);
            psDeleteGuardian.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psDeleteUser != null) try { psDeleteUser.close(); } catch (SQLException e) {}
            if (psDeleteGuardian != null) try { psDeleteGuardian.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
    
    // Get guardian by student ID
    public String[] getGuardianByStudentId(int studentId) throws SQLException {
        String sql = "SELECT g.Name, g.Phone, g.Email, g.Address, u.Username, u.Password " +
                     "FROM Guardian g " +
                     "LEFT JOIN Users u ON u.student_id = g.ST_ID AND u.Role = 'guardian' " +
                     "WHERE g.ST_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String[] guardian = new String[6];
                guardian[0] = rs.getString("Name");
                guardian[1] = rs.getString("Phone");
                guardian[2] = rs.getString("Email");
                guardian[3] = rs.getString("Address");
                guardian[4] = rs.getString("Username");
                guardian[5] = rs.getString("Password");
                return guardian;
            }
        }
        return null;
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
    
    // Check if guardian exists for student
    public boolean guardianExists(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Guardian WHERE ST_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    // ==================== PAYMENT MANAGEMENT ====================
    
    // Add payment for student
    public void addPayment(int studentId, String type, String details) throws SQLException {
        Connection con = null;
        PreparedStatement psPayment = null;
        PreparedStatement psType = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Insert into Payment table
            String sqlPayment = "INSERT INTO Payment (ST_ID) VALUES (?)";
            psPayment = con.prepareStatement(sqlPayment, Statement.RETURN_GENERATED_KEYS);
            psPayment.setInt(1, studentId);
            psPayment.executeUpdate();
            
            ResultSet rs = psPayment.getGeneratedKeys();
            int paymentId = 0;
            if (rs.next()) {
                paymentId = rs.getInt(1);
            }
            
            // Insert into specific payment type table
            if ("Cash".equals(type)) {
                String sqlCash = "INSERT INTO Cash (P_ID) VALUES (?)";
                psType = con.prepareStatement(sqlCash);
                psType.setInt(1, paymentId);
                psType.executeUpdate();
                
            } else if ("Card".equals(type)) {
                String sqlCard = "INSERT INTO Card (P_ID, C_ID) VALUES (?, ?)";
                psType = con.prepareStatement(sqlCard);
                psType.setInt(1, paymentId);
                psType.setString(2, details);
                psType.executeUpdate();
                
            } else if ("UPI".equals(type)) {
                String sqlUPI = "INSERT INTO UPI (P_ID, U_ID) VALUES (?, ?)";
                psType = con.prepareStatement(sqlUPI);
                psType.setInt(1, paymentId);
                psType.setString(2, details);
                psType.executeUpdate();
            }
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psPayment != null) try { psPayment.close(); } catch (SQLException e) {}
            if (psType != null) try { psType.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
    
    // Get all payments (Admin view)
    // Get all payments with formatted date
public List<String[]> getAllPayments() throws SQLException {
    List<String[]> list = new ArrayList<>();
    String sql = "SELECT p.P_ID, s.Name as StudentName, p.ST_ID, " +
                 "p.Payment_Type, p.Amount, DATE_FORMAT(p.Payment_Date, '%d-%m-%Y') as Payment_Date " +
                 "FROM Payment p " +
                 "JOIN Students s ON p.ST_ID = s.ST_ID " +
                 "ORDER BY p.P_ID DESC";
    try (Connection con = DBConnection.getConnection();
         Statement st = con.createStatement();
         ResultSet rs = st.executeQuery(sql)) {
        while (rs.next()) {
            String[] payment = new String[6];
            payment[0] = rs.getString("P_ID");
            payment[1] = rs.getString("StudentName");
            payment[2] = rs.getString("ST_ID");
            payment[3] = rs.getString("Payment_Type");
            payment[4] = rs.getString("Amount");
            payment[5] = rs.getString("Payment_Date");
            list.add(payment);
        }
    }
    return list;
}
    
   
    
    // Get total payments by student
    public int getTotalPaymentsByStudent(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Payment WHERE ST_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Get total payment amount by student
    public double getTotalPaymentAmountByStudent(int studentId) throws SQLException {
        // Assuming each payment is ₹25,000 (annual fee)
        int count = getTotalPaymentsByStudent(studentId);
        return count * 25000;
    }
    
    // Get payment by ID
    public String[] getPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT p.P_ID, s.Name as StudentName, p.ST_ID, " +
                     "CASE " +
                     "   WHEN c2.P_ID IS NOT NULL THEN 'Cash' " +
                     "   WHEN c3.P_ID IS NOT NULL THEN 'Card' " +
                     "   WHEN u.P_ID IS NOT NULL THEN 'UPI' " +
                     "END AS PaymentType, " +
                     "p.Payment_Date " +
                     "FROM Payment p " +
                     "JOIN Students s ON p.ST_ID = s.ST_ID " +
                     "LEFT JOIN Cash c2 ON p.P_ID = c2.P_ID " +
                     "LEFT JOIN Card c3 ON p.P_ID = c3.P_ID " +
                     "LEFT JOIN UPI u ON p.P_ID = u.P_ID " +
                     "WHERE p.P_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String[] payment = new String[5];
                payment[0] = rs.getString("P_ID");
                payment[1] = rs.getString("StudentName");
                payment[2] = rs.getString("ST_ID");
                payment[3] = rs.getString("PaymentType");
                payment[4] = rs.getString("Payment_Date");
                return payment;
            }
        }
        return null;
    }
    
    // Delete payment
    public void deletePayment(int paymentId) throws SQLException {
        Connection con = null;
        PreparedStatement psDeleteType = null;
        PreparedStatement psDeletePayment = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            // Delete from specific payment type table
            String sqlDeleteType = "DELETE FROM Cash WHERE P_ID = ?";
            psDeleteType = con.prepareStatement(sqlDeleteType);
            psDeleteType.setInt(1, paymentId);
            psDeleteType.executeUpdate();
            
            sqlDeleteType = "DELETE FROM Card WHERE P_ID = ?";
            psDeleteType = con.prepareStatement(sqlDeleteType);
            psDeleteType.setInt(1, paymentId);
            psDeleteType.executeUpdate();
            
            sqlDeleteType = "DELETE FROM UPI WHERE P_ID = ?";
            psDeleteType = con.prepareStatement(sqlDeleteType);
            psDeleteType.setInt(1, paymentId);
            psDeleteType.executeUpdate();
            
            // Delete from Payment table
            String sqlDeletePayment = "DELETE FROM Payment WHERE P_ID = ?";
            psDeletePayment = con.prepareStatement(sqlDeletePayment);
            psDeletePayment.setInt(1, paymentId);
            psDeletePayment.executeUpdate();
            
            con.commit();
            
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) {}
            }
            throw e;
        } finally {
            if (psDeleteType != null) try { psDeleteType.close(); } catch (SQLException e) {}
            if (psDeletePayment != null) try { psDeletePayment.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    }
    
    // Get payment summary for dashboard
    public Map<String, Object> getPaymentSummary() throws SQLException {
        Map<String, Object> summary = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) as total_payments, " +
                     "SUM(CASE WHEN c.P_ID IS NOT NULL THEN 1 ELSE 0 END) as cash_count, " +
                     "SUM(CASE WHEN ca.P_ID IS NOT NULL THEN 1 ELSE 0 END) as card_count, " +
                     "SUM(CASE WHEN u.P_ID IS NOT NULL THEN 1 ELSE 0 END) as upi_count " +
                     "FROM Payment p " +
                     "LEFT JOIN Cash c ON p.P_ID = c.P_ID " +
                     "LEFT JOIN Card ca ON p.P_ID = ca.P_ID " +
                     "LEFT JOIN UPI u ON p.P_ID = u.P_ID";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                summary.put("totalPayments", rs.getInt("total_payments"));
                summary.put("cashCount", rs.getInt("cash_count"));
                summary.put("cardCount", rs.getInt("card_count"));
                summary.put("upiCount", rs.getInt("upi_count"));
                summary.put("totalAmount", rs.getInt("total_payments") * 25000);
            }
        }
        return summary;
    }
    // Add payment with date
public void addPayment(int studentId, String paymentType, String details, String paymentDate) throws SQLException {
    Connection con = null;
    PreparedStatement ps = null;
    
    try {
        con = DBConnection.getConnection();
        String sql = "INSERT INTO Payment (ST_ID, Amount, Payment_Type, Details, Payment_Date) VALUES (?, ?, ?, ?, ?)";
        ps = con.prepareStatement(sql);
        ps.setInt(1, studentId);
        ps.setDouble(2, 25000); // Default fee amount
        ps.setString(3, paymentType);
        ps.setString(4, details);
        ps.setString(5, paymentDate);
        ps.executeUpdate();
        
    } catch (SQLException e) {
        throw e;
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
}
// Get payments by student with formatted date
public List<String[]> getPaymentsByStudent(int studentId) throws SQLException {
    List<String[]> list = new ArrayList<>();
    String sql = "SELECT P_ID, Payment_Type, Amount, DATE_FORMAT(Payment_Date, '%d-%m-%Y') as Payment_Date " +
                 "FROM Payment WHERE ST_ID = ? ORDER BY P_ID DESC";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            String[] payment = new String[4];
            payment[0] = rs.getString("P_ID");
            payment[1] = rs.getString("Payment_Type");
            payment[2] = rs.getString("Amount");
            payment[3] = rs.getString("Payment_Date");
            list.add(payment);
        }
    }
    return list;
}
}