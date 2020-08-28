package com.arch.holy.utils;

import com.arch.holy.model.response.ContentContainer;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonUtils {

    JsonUtils() {
    }

    public ContentContainer convertToContentContainer(String rawData){
        ContentContainer jsonData = null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            jsonData = mapper.readValue(rawData, ContentContainer.class);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return jsonData;
    }
}
