package com.arch.holy.management;

import com.arch.holy.model.bible.*;
import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.LineIterator;

import java.io.File;
import java.io.IOException;

public class SourceDataExtractor {

    private SourceDataInterpretator dataInterpretator;

    protected SourceDataExtractor() {
        dataInterpretator = new SourceDataInterpretator();
    }

    protected SourceDataExtractor setLoadSupplementIndexes(boolean loadSupplementIndexes) {
        this.dataInterpretator.setLoadSupplementIndexes(loadSupplementIndexes);
        return this;
    }

    /**
     * This method extracts data from file under dataPath param value and returns it in a Bible object.
     *
     * @param metadataCollector MetadataCollector object to collect supplement indexes
     * @param dataPath          Path to file with data to extract
     * @return Bible object with extracted data
     */
    protected Bible extractData(MetadataCollector metadataCollector, String dataPath) throws IOException {
        Bible bible = null;
        File dataFile = new File(dataPath);
        LineIterator iterator = null;
        try {
            iterator = FileUtils.lineIterator(dataFile, "UTF-8");
            bible = dataInterpretator.interpret(metadataCollector, iterator);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            iterator.close();
        }

        return bible;
    }

    /**
     * This method fills indexes regarding to bible structure members (e.g. verse to tome).
     *
     * @param metadataCollector MetadataCollector object to collect bible structure indexes
     * @param bible             Bible object
     */
    protected void fillBibleStructureIndexes(MetadataCollector metadataCollector, Bible bible) {
        for (Tome tome : bible.getTomes()) {
            TOME_ID tomeId = tome.getTomeId();
            TESTAMENT_ID testamentId = metadataCollector.findTestamentIdForTome(tomeId);

            for (Chapter chapter : tome.getChapters()) {
                int chapterAbsCardNum = chapter.getAbsoluteCardinalNumber();
                metadataCollector.addNewChapterToTestamentEntry(chapterAbsCardNum, testamentId);
                metadataCollector.addNewChapterToTomeEntry(chapterAbsCardNum, tomeId);

                for (Verse verse : chapter.getVerses()) {
                    int verseAbsCardNum = verse.getAbsoluteCardinalNumber();
                    Pericope pericope = tome.findPericopeWithVerse(verseAbsCardNum);
                    int pericopeAbsCardNum = (pericope == null) ? -1 : pericope.getAbsoluteCardinalNumber();
                    metadataCollector.addNewVerseToTomeEntry(verseAbsCardNum, tomeId);
                    metadataCollector.addNewVerseToChapterEntry(verseAbsCardNum, chapterAbsCardNum);
                    if (pericopeAbsCardNum != -1)
                        metadataCollector.addNewVerseToPericopeEntry(verseAbsCardNum, pericopeAbsCardNum);
                }
            }

            for (Pericope pericope : tome.getPericopes()) {
                int pericopeAbsCardNum = pericope.getAbsoluteCardinalNumber();
                metadataCollector.addNewPericopeToTestamentEntry(pericopeAbsCardNum, testamentId);
                metadataCollector.addNewPericopeToTomeEntry(pericopeAbsCardNum, tomeId);
            }
        }
    }
}
