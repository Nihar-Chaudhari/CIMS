package model;
public class Exam {
    private int eId, year, totalMarks;
    private String examName, eMode;
    private String examDate;

    public String getExamDate() { return examDate; }
    public void setExamDate(String examDate) { this.examDate = examDate; }
    
    public Exam() {}
    public Exam(int eId, String examName, int year, int totalMarks, String eMode) {
        this.eId = eId; this.examName = examName; this.year = year;
        this.totalMarks = totalMarks; this.eMode = eMode;
    }
    public int getEId() { return eId; }
    public void setEId(int eId) { this.eId = eId; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }
    public String getEMode() { return eMode; }
    public void setEMode(String eMode) { this.eMode = eMode; }
}
