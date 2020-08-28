package com.arch.holy.model.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(value = {"withLeftMargin", "bookmark", "audio"})
public class Content {

    private Integer prevChapter;

    private Integer nextChapter;

    private TomeMetadata tome;

    private Chapter chapter;

    public Content() {
    }

    public Content(Integer prevChapter, Integer nextChapter, TomeMetadata tome, Chapter chapter) {
        this.prevChapter = prevChapter;
        this.nextChapter = nextChapter;
        this.tome = tome;
        this.chapter = chapter;
    }

    public Integer getPrevChapter() {
        return prevChapter;
    }

    public void setPrevChapter(Integer prevChapter) {
        this.prevChapter = prevChapter;
    }

    public Integer getNextChapter() {
        return nextChapter;
    }

    public void setNextChapter(Integer nextChapter) {
        this.nextChapter = nextChapter;
    }

    public TomeMetadata getTome() {
        return tome;
    }

    public void setTome(TomeMetadata tome) {
        this.tome = tome;
    }

    public Chapter getChapter() {
        return chapter;
    }

    public void setChapter(Chapter chapter) {
        this.chapter = chapter;
    }
}
