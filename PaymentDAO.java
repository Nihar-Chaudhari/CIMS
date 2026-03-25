package dao;

import java.sql.*;
import java.util.*;

public class PaymentDAO {
    
    // Add new payment without Details column
    public void addPayment(int studentId, String paymentType, double amount, String details, String paymentDate) throws SQLException {
        String sql = "INSERT INTO Payment (ST_ID, Amount, Payment_Type, Payment_Date) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setDouble(2, amount);
            ps.setString(3, paymentType);
            ps.setString(4, paymentDate);
            ps.executeUpdate();
        }
    }
    
    // Get all payments (without Details column)
    public List<String[]> getAllPayments() throws SQLException {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT p.P_ID, s.Name, p.ST_ID, p.Payment_Type, p.Amount, p.Payment_Date " +
                     "FROM Payment p " +
                     "JOIN Students s ON p.ST_ID = s.ST_ID " +
                     "ORDER BY p.P_ID DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                String[] payment = new String[6];
                payment[0] = rs.getString("P_ID");
                payment[1] = rs.getString("Name");
                payment[2] = rs.getString("ST_ID");
                payment[3] = rs.getString("Payment_Type");
                payment[4] = rs.getString("Amount");
                payment[5] = rs.getString("Payment_Date");
                list.add(payment);
            }
        }
        return list;
    }
    
    // Get payments by student (without Details column)
    public List<String[]> getPaymentsByStudent(int studentId) throws SQLException {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT P_ID, Payment_Type, Amount, Payment_Date " +
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
    
    // Delete payment
    public void deletePayment(int paymentId) throws SQLException {
        String sql = "DELETE FROM Payment WHERE P_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ps.executeUpdate();
        }
    }
}