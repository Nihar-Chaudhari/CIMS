package model;
public class Attendance {
    private int aId, stId, tId, sId;
    private String attDate, status;
    public Attendance() {}
    public Attendance(int aId, int stId, int tId, int sId, String attDate, String status) {
        this.aId = aId; this.stId = stId; this.tId = tId;
        this.sId = sId; this.attDate = attDate; this.status = status;
    }
    public int getAId() { return aId; }
    public void setAId(int aId) { this.aId = aId; }
    public int getStId() { return stId; }
    public void setStId(int stId) { this.stId = stId; }
    public int getTId() { return tId; }
    public void setTId(int tId) { this.tId = tId; }
    public int getSId() { return sId; }
    public void setSId(int sId) { this.sId = sId; }
    public String getAttDate() { return attDate; }
    public void setAttDate(String attDate) { this.attDate = attDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
