package com.arch.holy.model.response.content;

public class Chapter {

    private String content;

    private String siglum;

    public Chapter() {
    }

    public Chapter(String content, String siglum) {
        this.content = content;
        this.siglum = siglum;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSiglum() {
        return siglum;
    }

    public void setSiglum(String siglum) {
        this.siglum = siglum;
    }
}
