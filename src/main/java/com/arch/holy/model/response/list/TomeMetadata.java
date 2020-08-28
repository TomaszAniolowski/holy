package com.arch.holy.model.response.list;

import java.util.List;

public class TomeMetadata {

    private int id;

    private String sigl;

    private String name;

    private boolean isNewTestament;

    private List<ChapterMetadata> chapters;

    public TomeMetadata() {
    }

    public TomeMetadata(int id, String sigl, String name, boolean isNewTestament, List<ChapterMetadata> chapters) {
        this.id = id;
        this.sigl = sigl;
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
