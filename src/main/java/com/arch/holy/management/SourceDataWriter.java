package com.arch.holy.management;


import com.arch.holy.model.bible.*;
import com.arch.holy.model.enums.*;
import com.arch.holy.utils.DocBuilder;
import org.apache.commons.lang3.StringUtils;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.util.*;

import static com.arch.holy.management.SourceDataConstants.*;

public class SourceDataWriter {

    private DocBuilder builder;

    public SourceDataWriter() {
        builder = new DocBuilder();
    }

    /**
     * Method saving data depending on parameters provided
     *
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param parameters        SourceDataParameters instance storing values determining what will be saved
     */
    protected void saveData(MetadataCollector metadataCollector, Bible bible, SourceDataParameters parameters) {
        if (parameters.isWriteMainData()) writeVerses(bible, metadataCollector);
        if (parameters.isWritePericopes()) writePericopes(bible);
        if (parameters.isWriteDefinitions()) writeDefinitions(bible.getDefinitions());
        if (parameters.isWriteDictionary()) writeDictionary(bible.getDictionary());
        if (parameters.isWriteSupplementIndexes()) writeSupplementIndexes(metadataCollector);
        if (parameters.isWriteDataStructureIndexes()) writeDataStructureIndexes(bible, metadataCollector);
    }

    /**
     * Method saving verses stored by Bible instance provided with information stored in MetadataCollector instance
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeVerses(Bible bible, MetadataCollector metadataCollector) {
        for (Chapter chapter : bible.getChapters()) {
            TOME_ID tomeId = chapter.getTomeId();
            int chapterAbsCardNum = chapter.getAbsoluteCardinalNumber();
            int chapterRelCardNum = chapter.getRelativeCardinalNumber();
            boolean isChapterFirstOne = metadataCollector.isChapterFirstOne(tomeId, chapterRelCardNum);
            boolean isChapterLastOne = metadataCollector.isChapterLastOne(tomeId, chapterRelCardNum);
            int prevChapterAbsCardNum = isChapterFirstOne ? -1 : chapter.getAbsoluteCardinalNumber() - 1;
            int nextChapterAbsCardNum = isChapterLastOne ? -1 : chapter.getAbsoluteCardinalNumber() + 1;

            Map<String, String> chapterAttributeMap = new HashMap<>();
            chapterAttributeMap.put(ABS_NUM_ATTR, String.valueOf(chapterAbsCardNum));
            chapterAttributeMap.put(REL_NUM_ATTR, String.valueOf(chapterRelCardNum));
            chapterAttributeMap.put(PREV_ATTR, String.valueOf(prevChapterAbsCardNum));
            chapterAttributeMap.put(NEXT_ATTR, String.valueOf(nextChapterAbsCardNum));
            chapterAttributeMap.put(TOME_ID_ATTR, metadataCollector.getTomeSiglum(tomeId));

            Document doc = builder.getNewDocument();
            if (doc == null) return;

            Element rootElement = doc.createElementNS(DATA_CH_NAMESPACE_URI, CHAPTER_ELM_WITH_PREFIX);
            doc.appendChild(rootElement);
            builder.fillElementWithAttributes(doc, rootElement, chapterAttributeMap);

            List<Verse> verses = chapter.getVerses();
            for (Verse verse : verses) {
                int verseAbsCardNum = verse.getAbsoluteCardinalNumber();
                String verseSiglum = verse.getSiglum();
                int prevVerseAbsCardNum = (verses.indexOf(verse) == 0) ? -1 : verseAbsCardNum - 1;
                int nextVerseAbsCardNum = (verses.indexOf(verse) == (verses.size() - 1)) ? -1 : verseAbsCardNum + 1;
                String verseContent = verse.getContent();

                Map<String, String> verseAttributeMap = new HashMap<>();
                verseAttributeMap.put(ABS_NUM_ATTR, String.valueOf(verseAbsCardNum));
                verseAttributeMap.put(SIGLUM_ATTR, verseSiglum);
                verseAttributeMap.put(PREV_ATTR, String.valueOf(prevVerseAbsCardNum));
                verseAttributeMap.put(NEXT_ATTR, String.valueOf(nextVerseAbsCardNum));

                Element verseElement = doc.createElementNS(DATA_CH_NAMESPACE_URI, VERSE_ELM_WITH_PREFIX);
                rootElement.appendChild(verseElement);
                builder.fillElementWithAttributes(doc, verseElement, verseAttributeMap);

                Text textNode = doc.createTextNode(verseContent);
                verseElement.appendChild(textNode);
            }

            String outputPath = getVersesOutputPath(metadataCollector, chapter);
            writeDataToXML(outputPath, doc);
        }
    }

    /**
     * Method saving pericopes stored by Bible instance provided with information stored in MetadataCollector instance
     *
     * @param bible Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     */
    private void writePericopes(Bible bible) {
        for (Tome tome : bible.getTomes()) {
            String quantity = String.valueOf(tome.getPericopes().size());
            Document doc = builder.getNewDocument();
            if (doc == null) return;

            Element rootElement = doc.createElementNS(DATA_PER_NAMESPACE_URI, PERICOPE_ROOT_ELM_WITH_PREFIX);
            doc.appendChild(rootElement);

            Attr quantityAttribute = doc.createAttribute(QUANTITY_ATTR);
            quantityAttribute.setValue(quantity);
            rootElement.setAttributeNode(quantityAttribute);

            List<Pericope> pericopes = tome.getPericopes();
            for (Pericope pericope : pericopes) {
                int pericopeAbsCardNum = pericope.getAbsoluteCardinalNumber();
                int pericopeRelCardNum = pericope.getRelativeCardinalNumber();
                String pericopeName = pericope.getName();
                int prevPericopeAbsCardNum = (pericopes.indexOf(pericope) == 0) ? -1 : pericopeAbsCardNum - 1;
                int nextPericopeAbsCardNum = (pericopes.indexOf(pericope) == (pericopes.size() - 1)) ? -1 : pericopeAbsCardNum + 1;
                int firstVerseAbsCardNum = pericope.getFirstVerseCardinalNumber();
                int lastVerseAbsCardNum = pericope.getLastVerseCardinalNumber();

                Map<String, String> attributeMap = new HashMap<>();
                attributeMap.put(ABS_NUM_ATTR, String.valueOf(pericopeAbsCardNum));
                attributeMap.put(REL_NUM_ATTR, String.valueOf(pericopeRelCardNum));
                attributeMap.put(PREV_ATTR, String.valueOf(prevPericopeAbsCardNum));
                attributeMap.put(NEXT_ATTR, String.valueOf(nextPericopeAbsCardNum));
                attributeMap.put(FIRST_VERSE_ATTR, String.valueOf(firstVerseAbsCardNum));
                attributeMap.put(LAST_VERSE_ATTR, String.valueOf(lastVerseAbsCardNum));

                Element pericopeElement = doc.createElementNS(DATA_PER_NAMESPACE_URI, PERICOPE_ELM_WITH_PREFIX);
                rootElement.appendChild(pericopeElement);
                builder.fillElementWithAttributes(doc, pericopeElement, attributeMap);

                Text pericopeTextNode = doc.createTextNode(pericopeName);
                pericopeElement.appendChild(pericopeTextNode);
            }

            String outputPath = getPericopesOutputPath(tome);
            writeDataToXML(outputPath, doc);
        }
    }

    /**
     * Method saving definitions provided in List o Supplement instances
     *
     * @param definitions List o Supplement instances storing definitions to save
     */
    private void writeDefinitions(List<Supplement> definitions) {
        if (definitions.size() == 0) return;

        Iterator<Supplement> definitionIterator = definitions.iterator();

        int entryCount = 0;
        int rangeStart = 0;

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(DATA_SUPP_NAMESPACE_URI, SUPPLEMENT_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        while (definitionIterator.hasNext()) {
            Supplement definition = definitionIterator.next();
            entryCount++;

            int entryId = definition.getId();
            String entryContent = definition.getContent();

            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ID_ATTR, String.valueOf(entryId));
            entryAttributeMap.put(SUPP_TYPE_ATTR, SUPPLEMENT_TYPE.DEF.toString());

            Element entryElement = doc.createElementNS(DATA_SUPP_NAMESPACE_URI, SUPPLEMENT_ENTRY_ELM_WITH_PREFIX);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);

            Text entryTextNode = doc.createTextNode(entryContent);
            entryElement.appendChild(entryTextNode);
            rootElement.appendChild(entryElement);

            if (entryCount == 1) {
                rangeStart = entryId;
            } else if (entryCount == DEFINITIONS_RANGE_LIMIT || !definitionIterator.hasNext()) {
                Map<String, String> rootAttributeMap = new HashMap<>();
                rootAttributeMap.put(RANGE_START_ATTR, String.valueOf(rangeStart));
                rootAttributeMap.put(RANGE_END_ATTR, String.valueOf(entryId));

                builder.fillElementWithAttributes(doc, rootElement, rootAttributeMap);

                String outputPath = String.format(DEFINITIONS_OUTPUT_PATH_TMPL, rangeStart, entryId);
                writeDataToXML(outputPath, doc);

                doc = builder.getNewDocument();
                if (doc == null) return;

                rootElement = doc.createElementNS(DATA_SUPP_NAMESPACE_URI, SUPPLEMENT_ROOT_ELM_WITH_PREFIX);
                doc.appendChild(rootElement);

                entryCount = 0;
            }
        }
    }

    /**
     * Method saving dictionary entries provided in List o Supplement instances
     *
     * @param dictionary List o Supplement instances storing dictionary entries to save
     */
    private void writeDictionary(List<Supplement> dictionary) {
        if (dictionary.size() == 0) return;

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(DATA_SUPP_NAMESPACE_URI, SUPPLEMENT_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        for (Supplement dictionaryEntry : dictionary) {
            int entryId = dictionaryEntry.getId();
            String entryContent = dictionaryEntry.getContent();
            String definiendum = StringUtils.substringBefore(entryContent, DICTIONARY_DEFINIENS_SEPARATOR);
            String definiens = StringUtils.substringAfter(entryContent, DICTIONARY_DEFINIENS_SEPARATOR);

            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ID_ATTR, String.valueOf(entryId));
            entryAttributeMap.put(SUPP_TYPE_ATTR, SUPPLEMENT_TYPE.DICT.toString());
            entryAttributeMap.put(DEFINIENDUM_ATTR, definiendum);

            Element entryElement = doc.createElementNS(DATA_SUPP_NAMESPACE_URI, SUPPLEMENT_ENTRY_ELM_WITH_PREFIX);
            rootElement.appendChild(entryElement);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);

            Text entryTextNode = doc.createTextNode(definiens);
            entryElement.appendChild(entryTextNode);
        }

        writeDataToXML(DICTIONARY_OUTPUT_PATH, doc);
    }

    /**
     * Method saving data structure indexes (e.g. Ps tome is included by OLD testament)
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeDataStructureIndexes(Bible bible, MetadataCollector metadataCollector) {
        writeVrsIndexes(bible, metadataCollector);
        writePrcpIndexes(bible, metadataCollector);
        writeChptrIndexes(bible, metadataCollector);
        writeTmIndexes(bible, metadataCollector);
        writeTsIndexes(bible, metadataCollector);
    }

    /**
     * Method saving supplement indexes (e.g. definiendum of definitiens 34 appears in Ps tome)
     *
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeSupplementIndexes(MetadataCollector metadataCollector) {
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.V, metadataCollector.getDefToVersesMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.P, metadataCollector.getDefToPericopesMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.CH, metadataCollector.getDefToChaptersMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.T, metadataCollector.getDefToTomesMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.V, metadataCollector.getDictToVersesMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.P, metadataCollector.getDictToPericopesMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.CH, metadataCollector.getDictToChaptersMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.SE, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.T, metadataCollector.getDictToTomesMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.V, metadataCollector.getVerseToDefMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.P, metadataCollector.getPericopesToDefMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.CH, metadataCollector.getChapterToDefMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DEF, ENTITY_TYPE.T, metadataCollector.getTomeToDefMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.V, metadataCollector.getVerseToDictMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.P, metadataCollector.getPericopesToDictMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.CH, metadataCollector.getChapterToDictMap());
        writeSpplmntIndexes(SUPP_INDEX_TYPE.ES, SUPPLEMENT_TYPE.DICT, ENTITY_TYPE.T, metadataCollector.getTomeToDictMap());
    }

    /**
     * Method saving data structure indexes concerning the verses
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeVrsIndexes(Bible bible, MetadataCollector metadataCollector) {
        Iterator<Map.Entry<Integer, Integer>> verseToChapterIterator = metadataCollector.getVerseToChapter().entrySet().iterator();

        int entryCount = 0;
        int rangeStart = 0;

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_V_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        while (verseToChapterIterator.hasNext()) {
            Map.Entry<Integer, Integer> entry = verseToChapterIterator.next();
            entryCount++;

            Verse verse = bible.findVerse(entry.getKey());
            int verseAbsNum = verse.getAbsoluteCardinalNumber();
            String verseSiglum = verse.getSiglum();
            Integer pericopeAbsNum = metadataCollector.getVerseToPericope().get(verseAbsNum);
            int chapterAbsNum = entry.getValue();
            TOME_ID tomeID = verse.getTomeId();
            TESTAMENT_ID testamentID = verse.getTestamentId();
            int tomeAbsNum = metadataCollector.getTomeCardinalNumber(tomeID);

            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ABS_NUM_ATTR, String.valueOf(verseAbsNum));
            entryAttributeMap.put(SIGLUM_ATTR, verseSiglum);
            entryAttributeMap.put(TESTAMENT_ID_ATTR, testamentID.toString());
            if (pericopeAbsNum != null) entryAttributeMap.put(PERICOPE_ABS_NUM_ATTR, String.valueOf(pericopeAbsNum));
            entryAttributeMap.put(CHAPTER_ABS_NUM_ATTR, String.valueOf(chapterAbsNum));
            entryAttributeMap.put(TOME_ABS_NUM_ATTR, String.valueOf(tomeAbsNum));

            Element entryElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_V_FST_CHILD_ELM_WITH_PREFIX);
            rootElement.appendChild(entryElement);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);

            if (entryCount == 1) {
                rangeStart = verseAbsNum;
            } else if (entryCount == GENERAL_INDEX_ENTRY_LIMIT || !verseToChapterIterator.hasNext()) {
                Map<String, String> rootAttributeMap = new HashMap<>();
                rootAttributeMap.put(RANGE_START_ATTR, String.valueOf(rangeStart));
                rootAttributeMap.put(RANGE_END_ATTR, String.valueOf(verseAbsNum));

                builder.fillElementWithAttributes(doc, rootElement, rootAttributeMap);

                String outputPath = String.format(V_INDEXES_OUTPUT_PATH_TMPL, rangeStart, verseAbsNum);
                writeDataToXML(outputPath, doc);

                doc = builder.getNewDocument();
                if (doc == null) return;

                rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_V_ROOT_ELM_WITH_PREFIX);
                doc.appendChild(rootElement);

                entryCount = 0;
            }
        }
    }

    /**
     * Method saving data structure indexes concerning the pericopes
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writePrcpIndexes(Bible bible, MetadataCollector metadataCollector) {
        Iterator<Map.Entry<Integer, TOME_ID>> pericopeToTomeIterator = metadataCollector.getPericopeToTome().entrySet().iterator();

        int entryCount = 0;
        int rangeStart = 0;

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_P_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        while (pericopeToTomeIterator.hasNext()) {
            Map.Entry<Integer, TOME_ID> entry = pericopeToTomeIterator.next();
            entryCount++;

            int pericopeAbsNum = entry.getKey();
            int tomeAbsNum = metadataCollector.getTomeCardinalNumber(entry.getValue());
            TESTAMENT_ID testamentID = bible.findTome(tomeAbsNum).getTestamentId();

            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ABS_NUM_ATTR, String.valueOf(pericopeAbsNum));
            entryAttributeMap.put(TOME_ABS_NUM_ATTR, String.valueOf(tomeAbsNum));
            entryAttributeMap.put(TESTAMENT_ID_ATTR, testamentID.toString());

            Element entryElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_P_FST_CHILD_ELM_WITH_PREFIX);
            rootElement.appendChild(entryElement);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);

            if (entryCount == 1) {
                rangeStart = pericopeAbsNum;
            } else if (entryCount == GENERAL_INDEX_ENTRY_LIMIT || !pericopeToTomeIterator.hasNext()) {
                Map<String, String> rootAttributeMap = new HashMap<>();
                rootAttributeMap.put(RANGE_START_ATTR, String.valueOf(rangeStart));
                rootAttributeMap.put(RANGE_END_ATTR, String.valueOf(pericopeAbsNum));

                builder.fillElementWithAttributes(doc, rootElement, rootAttributeMap);

                String outputPath = String.format(P_INDEXES_OUTPUT_PATH_TMPL, rangeStart, pericopeAbsNum);
                writeDataToXML(outputPath, doc);

                doc = builder.getNewDocument();
                if (doc == null) return;

                rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_P_ROOT_ELM_WITH_PREFIX);
                doc.appendChild(rootElement);

                entryCount = 0;
            }
        }
    }

    /**
     * Method saving data structure indexes concerning the chapters
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeChptrIndexes(Bible bible, MetadataCollector metadataCollector) {
        Iterator<Map.Entry<Integer, TOME_ID>> chapterToTomeIterator = metadataCollector.getChapterToTome().entrySet().iterator();

        int entryCount = 0;
        int rangeStart = 0;

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_CH_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        while (chapterToTomeIterator.hasNext()) {
            Map.Entry<Integer, TOME_ID> entry = chapterToTomeIterator.next();
            entryCount++;

            Chapter chapter = bible.findChapter(entry.getKey());
            int chapterAbsNum = chapter.getAbsoluteCardinalNumber();
            int chapterRelNum = chapter.getRelativeCardinalNumber();
            TOME_ID tomeID = chapter.getTomeId();
            TESTAMENT_ID testamentID = chapter.getTestamentId();
            int tomeAbsNum = metadataCollector.getTomeCardinalNumber(tomeID);
            String firstVerseSiglum = chapter.getFirstVerse().getSiglum();
            String lastVerseSiglum = chapter.getLastVerse().getSiglum();
            int firstVerseAbsNum = chapter.getFirstVerse().getAbsoluteCardinalNumber();
            int lastVerseAbsNum = chapter.getLastVerse().getAbsoluteCardinalNumber();


            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ABS_NUM_ATTR, String.valueOf(chapterAbsNum));
            entryAttributeMap.put(REL_NUM_ATTR, String.valueOf(chapterRelNum));
            entryAttributeMap.put(TOME_ABS_NUM_ATTR, String.valueOf(tomeAbsNum));
            entryAttributeMap.put(TESTAMENT_ID_ATTR, testamentID.toString());

            Element entryElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_CH_FST_CHILD_ELM_WITH_PREFIX);
            rootElement.appendChild(entryElement);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);


            Map<String, String> firstVerseAttributeMap = new HashMap<>();
            firstVerseAttributeMap.put(ABS_NUM_ATTR, String.valueOf(firstVerseAbsNum));
            firstVerseAttributeMap.put(SIGLUM_ATTR, firstVerseSiglum);

            Element firstVerseEl = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_CH_FIRST_VERSE_ELM_WITH_PREFIX);
            entryElement.appendChild(firstVerseEl);
            builder.fillElementWithAttributes(doc, firstVerseEl, firstVerseAttributeMap);


            Map<String, String> lastVerseAttributeMap = new HashMap<>();
            lastVerseAttributeMap.put(ABS_NUM_ATTR, String.valueOf(lastVerseAbsNum));
            lastVerseAttributeMap.put(SIGLUM_ATTR, lastVerseSiglum);

            Element lastVerseEl = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_CH_LAST_VERSE_ELM_WITH_PREFIX);
            entryElement.appendChild(lastVerseEl);
            builder.fillElementWithAttributes(doc, lastVerseEl, lastVerseAttributeMap);

            if (entryCount == 1) {
                rangeStart = chapterAbsNum;
            } else if (entryCount == GENERAL_INDEX_ENTRY_LIMIT || !chapterToTomeIterator.hasNext()) {
                Map<String, String> rootAttributeMap = new HashMap<>();
                rootAttributeMap.put(RANGE_START_ATTR, String.valueOf(rangeStart));
                rootAttributeMap.put(RANGE_END_ATTR, String.valueOf(chapterAbsNum));

                builder.fillElementWithAttributes(doc, rootElement, rootAttributeMap);

                String outputPath = String.format(CH_INDEXES_OUTPUT_PATH_TMPL, rangeStart, chapterAbsNum);
                writeDataToXML(outputPath, doc);

                doc = builder.getNewDocument();
                if (doc == null) return;

                rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_CH_ROOT_ELM_WITH_PREFIX);
                doc.appendChild(rootElement);

                entryCount = 0;
            }
        }
    }

    /**
     * Method saving data structure indexes concerning the tomes
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeTmIndexes(Bible bible, MetadataCollector metadataCollector) {

        List<Tome> tomes = bible.getTomes();

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_TM_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        Attr quantityAttribute = doc.createAttribute(QUANTITY_ATTR);
        quantityAttribute.setValue(String.valueOf(tomes.size()));
        rootElement.setAttributeNode(quantityAttribute);

        for (Tome tome : tomes) {
            int tomeAbsNum = tome.getAbsoluteCardinalNumber();
            int tomeRelNum = tome.getRelativeCardinalNumber();
            TESTAMENT_ID testamentID = tome.getTestamentId();
            int size = tome.getChapters().size();
            TOME_ID tomeId = tome.getTomeId();
            String firstChapterAbsNum = metadataCollector.getTomeFirstChapter(tomeId);
            String lastChapterAbsNum = metadataCollector.getTomeLastChapter(tomeId);
            int firstChapterRelNum = tome.getChapters().get(0).getRelativeCardinalNumber();
            int lastChapterRelNum = tome.getChapters().get(size - 1).getRelativeCardinalNumber();

            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ABS_NUM_ATTR, String.valueOf(tomeAbsNum));
            entryAttributeMap.put(REL_NUM_ATTR, String.valueOf(tomeRelNum));
            entryAttributeMap.put(TESTAMENT_ID_ATTR, testamentID.toString());
            entryAttributeMap.put(SIZE_ATTR, String.valueOf(size));

            Element entryElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_TM_FST_CHILD_ELM_WITH_PREFIX);
            rootElement.appendChild(entryElement);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);

            Map<String, String> firstChapterAttributeMap = new HashMap<>();
            firstChapterAttributeMap.put(ABS_NUM_ATTR, firstChapterAbsNum);
            firstChapterAttributeMap.put(REL_NUM_ATTR, String.valueOf(firstChapterRelNum));

            Element firstChapterEl = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_TM_FIRST_CHAPTER_ELM_WITH_PREFIX);
            entryElement.appendChild(firstChapterEl);
            builder.fillElementWithAttributes(doc, firstChapterEl, firstChapterAttributeMap);


            Map<String, String> lastChapterAttributeMap = new HashMap<>();
            lastChapterAttributeMap.put(ABS_NUM_ATTR, lastChapterAbsNum);
            lastChapterAttributeMap.put(REL_NUM_ATTR, String.valueOf(lastChapterRelNum));

            Element lastChapterEl = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_TM_LAST_CHAPTER_ELM_WITH_PREFIX);
            entryElement.appendChild(lastChapterEl);
            builder.fillElementWithAttributes(doc, lastChapterEl, lastChapterAttributeMap);
        }

        writeDataToXML(TM_INDEXES_OUTPUT_PATH, doc);
    }

    /**
     * Method saving data structure indexes concerning the testaments
     *
     * @param bible             Bible instance storing bible data (testaments, tomes, chapters, pericopes and verses)
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     */
    private void writeTsIndexes(Bible bible, MetadataCollector metadataCollector) {
        List<Testament> testaments = bible.getTestaments();

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_TST_ROOT_ELM_WITH_PREFIX);
        doc.appendChild(rootElement);

        for (Testament testament : testaments) {
            TESTAMENT_ID testamentId = testament.getId();
            int testamentAbsNum = (testamentId == TESTAMENT_ID.OLD) ? 1 : 2;
            int firstVerseAbsNum = metadataCollector.getTestamentFirstVerse(testamentId);
            int lastVerseAbsNum = metadataCollector.getTestamentLastVerse(testamentId);

            Map<String, String> entryAttributeMap = new HashMap<>();
            entryAttributeMap.put(ABS_NUM_ATTR, String.valueOf(testamentAbsNum));
            entryAttributeMap.put(REL_NUM_ATTR, testamentId.toString());
            entryAttributeMap.put(TST_FIRST_VERSE_ABS_NUM_ATTR, String.valueOf(firstVerseAbsNum));
            entryAttributeMap.put(TST_LAST_VERSE_ABS_NUM_ATTR, String.valueOf(lastVerseAbsNum));

            Element entryElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_TST_FST_CHILD_ELM_WITH_PREFIX);
            rootElement.appendChild(entryElement);
            builder.fillElementWithAttributes(doc, entryElement, entryAttributeMap);
        }

        writeDataToXML(TST_INDEXES_OUTPUT_PATH, doc);
    }

    /**
     * Method saving supplement indexes concerning the two-way relation between supplements on the one hand and verses, pericopes, chapters or tomes on the other
     * <p>
     * Supplements has the suppType type, entities have the entType type and relation between is stored by indexMap
     *
     * @param indexType type of supplement indexes (from entity to supplements or from the supplement to entities)
     * @param suppType  type of supplements contained by the indexes
     * @param entType   type of entity contained by the indexes
     * @param indexMap  Map of indexes storing references between the supplement on the left side and entities on the right side
     */
    private void writeSpplmntIndexes(SUPP_INDEX_TYPE indexType, SUPPLEMENT_TYPE suppType, ENTITY_TYPE entType, Map<Integer, Set<Integer>> indexMap) {
        final int RANGE_LIMIT = (indexType == SUPP_INDEX_TYPE.SE) ?
                ((suppType.equals(SUPPLEMENT_TYPE.DEF)) ? GENERAL_INDEX_ENTRY_LIMIT : DICTIONARY_INDEX_ENTRY_LIMIT) :
                ((entType.equals(ENTITY_TYPE.T)) ? TOME_SUPPLEMENT_INDEX_ENTRY_LIMIT : GENERAL_INDEX_ENTRY_LIMIT);
        final String ROOT_ELM_NAME = (indexType == SUPP_INDEX_TYPE.SE) ? METADATA_SE_ROOT_ELM_WITH_PREFIX : METADATA_ES_ROOT_ELM_WITH_PREFIX;
        final String ENTRY_ELM_NAME = (indexType == SUPP_INDEX_TYPE.SE) ? METADATA_SE_FST_CHILD_ELM_WITH_PREFIX : METADATA_ES_FST_CHILD_ELM_WITH_PREFIX;

        Iterator<Map.Entry<Integer, Set<Integer>>> indexMapIterator = indexMap.entrySet().iterator();

        int entryCount = 0;
        int rangeStart = 0;

        Document doc = builder.getNewDocument();
        if (doc == null) return;

        Element rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, ROOT_ELM_NAME);
        doc.appendChild(rootElement);

        while (indexMapIterator.hasNext()) {
            Map.Entry<Integer, Set<Integer>> indexMapEntry = indexMapIterator.next();
            entryCount++;

            int keyAbsNum = indexMapEntry.getKey();
            Set<Integer> ids = indexMapEntry.getValue();
            int quantity = ids.size();


            Map<String, String> keyEntryAttributeMap = new HashMap<>();
            keyEntryAttributeMap.put(ID_ATTR, String.valueOf(keyAbsNum));
            keyEntryAttributeMap.put(QUANTITY_ATTR, String.valueOf(quantity));

            Element keyEntryElement = doc.createElementNS(METADATA_NAMESPACE_URI, ENTRY_ELM_NAME);
            rootElement.appendChild(keyEntryElement);
            builder.fillElementWithAttributes(doc, keyEntryElement, keyEntryAttributeMap);

            for (int id : ids) {
                Map<String, String> valueEntryAttributeMap = new HashMap<>();
                valueEntryAttributeMap.put(SUPP_TYPE_ATTR, suppType.toString());
                valueEntryAttributeMap.put(ENT_TYPE_ATTR, entType.toString());
                valueEntryAttributeMap.put(SUPP_ID_ATTR, String.valueOf(keyAbsNum));
                valueEntryAttributeMap.put(ENT_ABS_NUM_ATTR, String.valueOf(id));

                Element valueEntryElement = doc.createElementNS(METADATA_NAMESPACE_URI, METADATA_SUPP_ENTRY_ELM_WITH_PREFIX);
                keyEntryElement.appendChild(valueEntryElement);
                builder.fillElementWithAttributes(doc, valueEntryElement, valueEntryAttributeMap);
            }


            if (entryCount == 1) {
                rangeStart = keyAbsNum;
            } else if (entryCount == RANGE_LIMIT || !indexMapIterator.hasNext()) {
                Map<String, String> rootAttributeMap = new HashMap<>();
                rootAttributeMap.put(SUPP_TYPE_ATTR, suppType.toString());
                rootAttributeMap.put(ENT_TYPE_ATTR, entType.toString());
                rootAttributeMap.put(RANGE_START_ATTR, String.valueOf(rangeStart));
                rootAttributeMap.put(RANGE_END_ATTR, String.valueOf(keyAbsNum));

                builder.fillElementWithAttributes(doc, rootElement, rootAttributeMap);

                String outputPath = getSuppIndexesOutputPath(indexType, suppType, entType, rangeStart, keyAbsNum);
                writeDataToXML(outputPath, doc);

                doc = builder.getNewDocument();
                if (doc == null) return;

                rootElement = doc.createElementNS(METADATA_NAMESPACE_URI, ROOT_ELM_NAME);
                doc.appendChild(rootElement);

                entryCount = 0;
            }
        }
    }

    /**
     * Method creating the output path for verses from the template
     *
     * @param metadataCollector MetadataCollector instance storing bible meta data (e.g. references between supplements and verses)
     * @param chapter           Chapter instance storing the verses to save
     * @return output path for verses
     */
    private String getVersesOutputPath(MetadataCollector metadataCollector, Chapter chapter) {
        int tomeAbsCardNum = metadataCollector.getTomeCardinalNumber(chapter.getTomeId());
        String tomeSiglum = replacePolishChars(metadataCollector.getTomeSiglum(chapter.getTomeId()));
        int chapterAbsCardNum = chapter.getAbsoluteCardinalNumber();
        int chapterRelCardNum = chapter.getRelativeCardinalNumber();
        return String.format(TOME_OUTPUT_PATH_TMPL, tomeAbsCardNum, tomeSiglum, chapterAbsCardNum, chapterRelCardNum);
    }

    /**
     * Method creating the output path for pericopes from the template
     *
     * @param tome Tome instance storing the pericopes to save
     * @return output path for pericopes
     */
    private String getPericopesOutputPath(Tome tome) {
        int tomeAbsCardNum = tome.getAbsoluteCardinalNumber();
        String tomeSiglum = replacePolishChars(tome.getTomeSiglum());
        return String.format(PERICOPE_OUTPUT_PATH_TMPL, tomeAbsCardNum, tomeSiglum);
    }

    /**
     * Method creating the output path for the supplement indexes from the template
     *
     * @param indexType  supplement index type
     * @param suppType   supplement type
     * @param entType    entity type
     * @param rangeStart integer value of the starting point for the range
     * @param rangeEnd   integer value of the ending point for the range
     * @return output path for the supplement indexes
     */
    private String getSuppIndexesOutputPath(SUPP_INDEX_TYPE indexType, SUPPLEMENT_TYPE suppType, ENTITY_TYPE entType, int rangeStart, int rangeEnd) {
        if (indexType == SUPP_INDEX_TYPE.SE && entType == ENTITY_TYPE.V)
            return String.format(SV_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.SE && entType == ENTITY_TYPE.P)
            return String.format(SP_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.SE && entType == ENTITY_TYPE.CH)
            return String.format(SCH_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.SE && entType == ENTITY_TYPE.T)
            return String.format(ST_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.ES && entType == ENTITY_TYPE.V)
            return String.format(VS_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.ES && entType == ENTITY_TYPE.P)
            return String.format(PS_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.ES && entType == ENTITY_TYPE.CH)
            return String.format(CHS_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else if (indexType == SUPP_INDEX_TYPE.ES && entType == ENTITY_TYPE.T)
            return String.format(TS_INDEXES_OUTPUT_PATH_TMPL, suppType, rangeStart, rangeEnd);
        else return BLANK;
    }

    /**
     * Method replacing polish characters in parameter provided
     *
     * @param str String to replace the polish characters
     * @return String value of str parameter without polish characters
     */
    private String replacePolishChars(String str) {
        return str.replace("ą", "a")
                .replace("ć", "c")
                .replace("ę", "e")
                .replace("ł", "l")
                .replace("ń", "n")
                .replace("ó", "o")
                .replace("ś", "s")
                .replace("ź", "z")
                .replace("ż", "z")
                .replace("Ą", "A")
                .replace("Ć", "C")
                .replace("Ę", "E")
                .replace("Ł", "L")
                .replace("Ń", "N")
                .replace("Ó", "O")
                .replace("Ś", "S")
                .replace("Ź", "Z")
                .replace("Ż", "Z");
    }

    /**
     * Method writing xml documents under the output path provided
     *
     * @param outputPath      String value of the output path
     * @param chapterDocument Document instance containing document node to save
     */
    private void writeDataToXML(String outputPath, Document chapterDocument) {
        try {
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(chapterDocument);
            File file = new File(outputPath);
            file.getParentFile().mkdirs();
            StreamResult result = new StreamResult(file);
            transformer.transform(source, result);
        } catch (TransformerException e) {
            e.printStackTrace();
        }
    }
}
