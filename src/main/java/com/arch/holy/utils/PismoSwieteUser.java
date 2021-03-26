package com.arch.holy.utils;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.UnsupportedEncodingException;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class PismoSwieteUser implements BrowserUser {

    private static final String LOGIN_PAGE_URL = "https://pismoswiete.pl/login";
    private static final String FORM_TARGET_URL = "https://pismoswiete.pl/login_check";
    private static final String SESSION_COOKIE_KEY = "PHPSESSID";
    private static final Map<String,String> GET_LOGIN_PAGE_REQ_PARAMS = new HashMap<String,String>() {{
        put("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36");
        put("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
        put("Accept-Language", "en-US,en;q=0.5");
        put("accept-encoding", "gzip, deflate, br");
        put("accept-language", "pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7");
        put("pragma", "no-cache");
        put("sec-fetch-dest", "document");
        put("sec-fetch-mode", "navigate");
        put("sec-fetch-site", "none");
        put("upgrade-insecure-requests", "1");
    }};

    private RequestSender sender;
    private Map<String, String> postFormReqParams;

    public PismoSwieteUser() {
        sender = RequestSenderFactory.getNewRequestSender();
        postFormReqParams = new HashMap<String,String>() {{
            put("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36");
            put("accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");
            put("accept-encoding", "gzip, deflate, br");
            put("accept-language", "pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7");
            put("cache-control", "no-cache");
            put("content-type", "application/x-www-form-urlencoded");
            put("origin", "https://pismoswiete.pl");
            put("pragma", "no-cache");
            put("referer", "https://pismoswiete.pl/login");
            put("sec-fetch-dest", "document");
            put("sec-fetch-mode", "navigate");
            put("sec-fetch-site", "same-origin");
            put("sec-fetch-user", "?1");
            put("upgrade-insecure-requests", "1");
        }};
    }

    @Override
    public String login(Map<String, String> credentials) {
        String sessionId = "";
        String login = Optional.ofNullable(credentials.get(BrowserUser.LOGIN_KEY)).orElse("");
        String password = Optional.ofNullable(credentials.get(BrowserUser.PASSWORD_KEY)).orElse("");

        CookieManager cookieManager = new CookieManager();
        CookieHandler.setDefault(cookieManager);

        String loginFormResponse = sender.GET(LOGIN_PAGE_URL, GET_LOGIN_PAGE_REQ_PARAMS);
        String formParameters = getFormParameters(loginFormResponse, login, password);
        postFormReqParams.put("content-length", Integer.toString(formParameters.length()));

        sender.POST(FORM_TARGET_URL, postFormReqParams, formParameters);

        HttpCookie cookie = cookieManager.getCookieStore().getCookies().stream().filter(c -> c.getName().equals(SESSION_COOKIE_KEY)).findFirst().orElse(null);
        sessionId = (cookie == null) ? sessionId : cookie.getValue();

        return sessionId;
    }

    private static String getFormParameters(String loginFormResponse, String login, String password) {
        Document doc = Jsoup.parse(loginFormResponse);
        Element form = doc.getElementsByTag("form").get(0);
        Elements inputElements = form.getElementsByTag("input");

        List<String> paramList = new ArrayList<>();
        for (Element inputElement : inputElements) {
            String key = inputElement.attr("name");
            String value = inputElement.attr("value");

            if (key.equals("_username"))
                value = login;
            else if (key.equals("_password"))
                value = password;
            try {
                paramList.add(key + "=" + URLEncoder.encode(value, "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }

        StringBuilder result = new StringBuilder();
        for (String param : paramList) {
            if (result.length() == 0) {
                result.append(param);
            } else {
                result.append("&").append(param);
            }
        }

        return result.toString();
    }


}
