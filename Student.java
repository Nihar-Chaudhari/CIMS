package model;

public class Student {
    private int stId;
    private String name, dob, phone, address;
    private String username, password;

    public Student() {}

    public Student(int stId, String name, String dob, String phone, String address) {
        this.stId = stId;
        this.name = name;
        this.dob = dob;
        this.phone = phone;
        this.address = address;
    }

    public Student(int stId, String name, String dob, String phone, String address, 
                   String username, String password) {
        this.stId = stId;
        this.name = name;
        this.dob = dob;
        this.phone = phone;
        this.address = address;
        this.username = username;
        this.password = password;
    }

    // Getters and Setters
    public int getStId() { return stId; }
    public void setStId(int stId) { this.stId = stId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDob() { return dob; }
    public void setDob(String dob) { this.dob = dob; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}