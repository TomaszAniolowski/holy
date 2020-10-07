package com.arch.holy.management;

import com.arch.holy.model.bible.Bible;
import com.arch.holy.model.bible.MetadataCollector;
import com.arch.holy.model.bible.MetadataCollectorFactory;
import com.arch.holy.model.response.ContentContainerList;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class SourceDataManager {

    private SourceDataCollector collector;
    private SourceDataExtractor extractor;
    private SourceDataWriter writer;
    private MetadataCollector metadataCollector;
    private boolean loadStructureIndexes;

    public SourceDataManager(String session) {
        this.collector = new SourceDataCollector(session);
        this.extractor = new SourceDataExtractor();
        this.writer = new SourceDataWriter();
        this.metadataCollector = MetadataCollectorFactory.createNewCollector();
        this.loadStructureIndexes = true;
    }

    public void run() throws IOException {
        TreeMap<String, String> tomeLastChaptersMap = metadataCollector.getTomeLastChaptersMap();
        List<ContentContainerList> tomesContent = collector.getTomesContent(tomeLastChaptersMap);
        collector.saveChapterHTML(metadataCollector, tomesContent);

        Bible bible = extractor.extractData(metadataCollector, getLatestBibleContentPath());
        if (loadStructureIndexes) extractor.fillBibleStructureIndexes(metadataCollector, bible);

//        SourceDataParameters sourceDataParameters = new SourceDataParameters(false, false, true, false, false, false);
        SourceDataParameters sourceDataParameters = new SourceDataParameters();
        writer.saveData(metadataCollector, bible, sourceDataParameters);
    }

    public SourceDataManager setLoadSupplementIndexes(boolean loadSupplementIndexes) {
        this.extractor.setLoadSupplementIndexes(loadSupplementIndexes);
        return this;
    }

    public SourceDataManager setLoadStructureIndexes(boolean loadStructureIndexes) {
        this.loadStructureIndexes = loadStructureIndexes;
        return this;
    }

    private String getLatestBibleContentPath(){
        String storagePath = StringUtils.substringBefore(SourceDataConstants.BIBLE_CONTENT_FILE_PATH, "bible-content");
        File file = new File(storagePath);
        String latestContentPath = Arrays.stream(Objects.requireNonNull(file.list()))
            .filter(s -> s.matches("bible-content_(\\d){14}"))
            .sorted(Comparator.reverseOrder())
            .limit(1)
            .collect(Collectors.joining());

        return latestContentPath;
    }
}
