package com.arch.holy.utils;

import java.util.Map;

public interface BrowserUser {

    String LOGIN_KEY = "login";
    String PASSWORD_KEY = "password";

    /**
     * It logs in user with credentials provided and returns the session id
     *
     * @param credentials map with login and password
     * @return String value of th session id
     */
    String login(Map<String, String> credentials);
}
