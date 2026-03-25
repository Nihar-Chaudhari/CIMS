package dao;
import model.Material;
import java.sql.*;
import java.util.*;

public class MaterialDAO {
    public void addMaterial(Material m) throws SQLException {
    String checkSql = "SELECT S_ID FROM Subject WHERE S_ID=?";
    String insertSql = "INSERT INTO Material (T_ID,S_ID,Title,Description,File_Link,Upload_Date) VALUES (?,?,?,?,?,?)";

    try (Connection con = DBConnection.getConnection()) {

        // 🔍 Step 1: Check if subject exists
        PreparedStatement checkPs = con.prepareStatement(checkSql);
        checkPs.setInt(1, m.getSId());
        ResultSet rs = checkPs.executeQuery();

        if (!rs.next()) {
            throw new SQLException("Invalid S_ID: Subject does not exist!");
        }

        // ✅ Step 2: Insert only if valid
        PreparedStatement ps = con.prepareStatement(insertSql);
        ps.setInt(1, m.getTId());
        ps.setInt(2, m.getSId());
        ps.setString(3, m.getTitle());
        ps.setString(4, m.getDescription());
        ps.setString(5, m.getFileLink());
        ps.setString(6, m.getUploadDate());

        ps.executeUpdate();
    }
}
    public List<Material> getMaterialBySubject(int sId) throws SQLException {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT * FROM Material WHERE S_ID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sId);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(new Material(rs.getInt("M_ID"), rs.getInt("T_ID"),
                    rs.getInt("S_ID"), rs.getString("Title"),
                    rs.getString("Description"), rs.getString("File_Link"),
                    rs.getString("Upload_Date")));
        }
        return list;
    }
    public List<Material> getAllMaterial() throws SQLException {
        List<Material> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM Material")) {
            while (rs.next())
                list.add(new Material(rs.getInt("M_ID"), rs.getInt("T_ID"),
                    rs.getInt("S_ID"), rs.getString("Title"),
                    rs.getString("Description"), rs.getString("File_Link"),
                    rs.getString("Upload_Date")));
        }
        return list;
    }
}
