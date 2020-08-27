package com.arch.holy.model.bible;

import java.util.ArrayList;
import java.util.List;

public class MetadataCollectorFactory {

    private static List<MetadataCollector> metadataCollectors = new ArrayList<>();

    public static MetadataCollector createNewCollector(){
        MetadataCollector collector = new MetadataCollector();
        metadataCollectors.add(collector);
        return collector;
    }
}
