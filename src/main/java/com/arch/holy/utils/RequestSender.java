package com.arch.holy.utils;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class RequestSender {

    private static final String GET_REQUEST = "GET";
    private static final String POST_REQUEST = "POST";

    public String GET(String urlValue, Map<String, String> requestParams) {
        String response = "";
        try {
            URL url = new URL(urlValue);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(GET_REQUEST);
            conn.setUseCaches(false);
            if (requestParams != null) {
                for (Map.Entry<String, String> requestParam : requestParams.entrySet()) {
                    conn.setRequestProperty(requestParam.getKey(), requestParam.getValue());
                }
            }
            conn.connect();
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
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

    public int POST(String urlValue, Map<String, String> requestParams, String postParams) {
        int responseCode = -1;
        try {
            URL url = new URL(urlValue);
            HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
            conn.setRequestMethod(POST_REQUEST);
            conn.setUseCaches(false);
            conn.setDoOutput(true);
            conn.setDoInput(true);
            if (requestParams != null) {
                for (Map.Entry<String, String> requestParam : requestParams.entrySet()) {
                    conn.setRequestProperty(requestParam.getKey(), requestParam.getValue());
                }
            }

            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();

            responseCode = conn.getResponseCode();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return responseCode;
    }
}
