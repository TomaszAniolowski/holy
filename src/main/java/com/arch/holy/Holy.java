package com.arch.holy;

import com.arch.holy.management.SourceDataManager;

import java.io.IOException;

public class Holy {
    public static void main(String[] args) {
        SourceDataManager manager = new SourceDataManager();
        try {
            manager.run();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
