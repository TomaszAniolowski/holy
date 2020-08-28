package com.arch.holy.model.response.content;

public class Chapter {

    private String content;

    private String sigl;

    public Chapter() {
    }

    public Chapter(String content, String sigl) {
        this.content = content;
        this.sigl = sigl;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSigl() {
        return sigl;
    }

    public void setSigl(String sigl) {
        this.sigl = sigl;
    }
}
