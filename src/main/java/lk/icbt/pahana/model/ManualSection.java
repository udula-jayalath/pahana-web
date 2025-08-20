package lk.icbt.pahana.model;

public class ManualSection {
    private String id;
    private String title;
    private String html; // preformatted HTML snippet

    public ManualSection() {}
    public ManualSection(String id, String title, String html) {
        this.id = id; this.title = title; this.html = html;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getHtml() { return html; }
    public void setHtml(String html) { this.html = html; }
}
