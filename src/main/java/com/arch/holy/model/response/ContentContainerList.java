package com.arch.holy.model.response;

import java.util.ArrayList;
import java.util.List;

public class ContentContainerList {

    List<ContentContainer> tomeList;

    public ContentContainerList() {
        tomeList = new ArrayList<>();
    }

    public ContentContainerList(List<ContentContainer> tomeList) {
        this.tomeList = tomeList;
    }

    public List<ContentContainer> getTomeList() {
        return tomeList;
    }

    public void setTomeList(List<ContentContainer> tomeList) {
        this.tomeList = tomeList;
    }
}
