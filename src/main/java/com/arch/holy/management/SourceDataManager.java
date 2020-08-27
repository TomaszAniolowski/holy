package com.arch.holy.management;

import com.arch.holy.model.bible.Bible;
import com.arch.holy.model.bible.MetadataCollector;
import com.arch.holy.model.bible.MetadataCollectorFactory;

import java.io.IOException;

public class SourceDataManager {

    private SourceDataCollector collector;
    private SourceDataExtractor extractor;
    private SourceDataWriter writer;
    private MetadataCollector metadataCollector;
    private String session;
    private boolean loadStructureIndexes;

    public SourceDataManager() {
        this(SourceDataConstants.BLANK);
    }

    public SourceDataManager(String session) {
        this.collector = new SourceDataCollector();
        this.extractor = new SourceDataExtractor();
        this.writer = new SourceDataWriter();
        this.metadataCollector = MetadataCollectorFactory.createNewCollector();
        this.session = session;
        this.loadStructureIndexes = true;
    }

    public void run() throws IOException {
//        TreeMap<String, String> tomeLastChaptersMap = metadataCollector.getTomeLastChaptersMap();
//        List<ContentContainerList> tomesContent = collector.getTomesContent(session, tomeLastChaptersMap);
//        collector.saveChapterHTML(metadataCollector, tomesContent, SourceDataConstants.BIBLE_CONTENT_FILE_PATH, true);

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
