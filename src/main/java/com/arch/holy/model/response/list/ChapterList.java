package com.arch.holy.model.response.list;

import com.arch.holy.model.response.BibleResponse;

import java.util.List;

public class ChapterList implements BibleResponse {

    private boolean success;

    private List<TomeMetadata> data;

    public ChapterList() {
    }

    public ChapterList(boolean success, List<TomeMetadata> data) {
        this.success = success;
        this.data = data;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public List<TomeMetadata> getData() {
        return data;
    }

    public void setData(List<TomeMetadata> data) {
        this.data = data;
    }
}
