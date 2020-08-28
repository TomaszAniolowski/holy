package com.arch.holy.model.response;

import com.arch.holy.management.SourceDataConstants;

import java.util.Map;

public class ContentContainer {

    private boolean success;

    private Content data;

    public ContentContainer() {
    }

    public ContentContainer(boolean success, Content data) {
        this.success = success;
        this.data = data;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Content getData() {
        return data;
    }

    public void setData(Content data) {
        this.data = data;
    }

    public String getChapterContent(){
        return this.data.getChapter().getContent();
    }

    public void setChapterContent(String content) {
        this.data.getChapter().setContent(content);
    }

    public String getChapterContentDecoded() {
        String content = this.getChapterContent();
        for (Map.Entry<String, String> mapEntry : SourceDataConstants.DECODER_MAP.entrySet()) {
            String key = mapEntry.getKey();
            String value = mapEntry.getValue();
            content = content.replace(key, value);
        }
        return content;
    }
}
