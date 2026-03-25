package model;
public class Material {
    private int mId, tId, sId;
    private String title, description, fileLink, uploadDate;
    public Material() {}
    public Material(int mId, int tId, int sId, String title,
                    String description, String fileLink, String uploadDate) {
        this.mId = mId; this.tId = tId; this.sId = sId;
        this.title = title; this.description = description;
        this.fileLink = fileLink; this.uploadDate = uploadDate;
    }
    public int getMId() { return mId; }
    public void setMId(int mId) { this.mId = mId; }
    public int getTId() { return tId; }
    public void setTId(int tId) { this.tId = tId; }
    public int getSId() { return sId; }
    public void setSId(int sId) { this.sId = sId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String d) { this.description = d; }
    public String getFileLink() { return fileLink; }
    public void setFileLink(String fileLink) { this.fileLink = fileLink; }
    public String getUploadDate() { return uploadDate; }
    public void setUploadDate(String uploadDate) { this.uploadDate = uploadDate; }
}
