package com.arch.holy;

import com.arch.holy.management.SourceDataManager;
import com.arch.holy.utils.BrowserUser;
import com.arch.holy.utils.PismoSwieteUser;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class Holy {
    public static void main(String[] args) {
        Map<String,String> credentials = new HashMap<>(){{
            put(BrowserUser.LOGIN_KEY, args[0]);
            put(BrowserUser.PASSWORD_KEY, args[1]);
        }};
        BrowserUser user = new PismoSwieteUser();
        String sessionId = user.login(credentials);

        SourceDataManager manager = new SourceDataManager(sessionId);
        try {
            manager.run();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
