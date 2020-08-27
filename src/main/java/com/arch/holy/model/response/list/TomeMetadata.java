package com.arch.holy.model.response.list;

import java.util.List;

public class TomeMetadata {

    private int id;

    private String siglum;

    private String name;

    private boolean isNewTestament;

    private List<ChapterMetadata> chapters;

    public TomeMetadata() {
    }

    public TomeMetadata(int id, String siglum, String name, boolean isNewTestament, List<ChapterMetadata> chapters) {
        this.id = id;
        this.siglum = siglum;
        this.name = name;
        this.isNewTestament = isNewTestament;
        this.chapters = chapters;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public boolean getIsNewTestament() {
        return isNewTestament;
    }

    public void setIsNewTestament(boolean newTestament) {
        isNewTestament = newTestament;
    }

    public List<ChapterMetadata> getChapters() {
        return chapters;
    }

    public void setChapters(List<ChapterMetadata> chapters) {
        this.chapters = chapters;
    }
}
