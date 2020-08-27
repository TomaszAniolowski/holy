package com.arch.holy.model.response.content;

public class TomeMetadata {

    private String siglum;

    private String name;

    private String content;

    public TomeMetadata() {
    }

    public TomeMetadata(String siglum, String name, String content) {
        this.siglum = siglum;
        this.name = name;
        this.content = content;
    }

    public String getSiglum() {
        return siglum;
    }

    public void setSiglum(String siglum) {
        this.siglum = siglum;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
