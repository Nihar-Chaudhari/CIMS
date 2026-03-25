package model;

public class Teacher {
    private int tId;
    private String tName, address, phone;
    private double salary;
    private String username, password;  // Added login credentials

    public Teacher() {}

    public Teacher(int tId, String tName, String address, String phone, double salary) {
        this.tId = tId;
        this.tName = tName;
        this.address = address;
        this.phone = phone;
        this.salary = salary;
    }

    public Teacher(int tId, String tName, String address, String phone, double salary,
                   String username, String password) {
        this.tId = tId;
        this.tName = tName;
        this.address = address;
        this.phone = phone;
        this.salary = salary;
        this.username = username;
        this.password = password;
    }

    // Getters and Setters
    public int getTId() { return tId; }
    public void setTId(int tId) { this.tId = tId; }
    
    public String getTName() { return tName; }
    public void setTName(String tName) { this.tName = tName; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}