package com.arch.holy.model.response.content;

public class TomeMetadata {

    private String sigl;

    private String name;

    private String content;

    public TomeMetadata() {
    }

    public TomeMetadata(String sigl, String name, String content) {
        this.sigl = sigl;
        this.name = name;
        this.content = content;
    }

    public String getSigl() {
        return sigl;
    }

    public void setSigl(String sigl) {
        this.sigl = sigl;
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
