package com.arch.holy.utils;

import com.arch.holy.management.SourceDataConstants;
import org.apache.commons.lang3.StringUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class RequestSender {

    private static final String GET_REQUEST = "GET";
    private static final String COOKIE_PROPERTY = "Cookie";

    private String rawResponse;

    RequestSender() {
    }

    public String GET(String urlValue) {
        return GET(urlValue, SourceDataConstants.BLANK);
    }

    public String GET(String urlValue, String cookie) {
        String response = "";
        try {
            URL url = new URL(urlValue);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(GET_REQUEST);
            if (StringUtils.isNotBlank(cookie)) {
                conn.setRequestProperty(COOKIE_PROPERTY, cookie);
            }
            conn.connect();
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) content.append(inputLine);

            in.close();
            response = content.toString();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return response;
    }
}
