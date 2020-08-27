package com.arch.holy.utils;

import com.arch.holy.model.response.BibleResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonUtils {

    JsonUtils() {
    }

    public BibleResponse convertToBibleResponseInstance(String rawData, Class type){
        BibleResponse jsonData = null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            jsonData = (BibleResponse) mapper.readValue(rawData, type);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return jsonData;
    }
}
