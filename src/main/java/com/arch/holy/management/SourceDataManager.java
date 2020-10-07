package com.arch.holy.management;

import com.arch.holy.model.bible.Bible;
import com.arch.holy.model.bible.MetadataCollector;
import com.arch.holy.model.bible.MetadataCollectorFactory;
import com.arch.holy.model.response.ContentContainerList;

import java.io.IOException;
import java.util.List;
import java.util.TreeMap;

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

        Bible bible = extractor.extractData(metadataCollector, SourceDataConstants.BIBLE_CONTENT_FILE_PATH);
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
}
