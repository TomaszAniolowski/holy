package com.arch.holy.management;

import com.arch.holy.model.bible.*;
import com.arch.holy.model.enums.SUPPLEMENT_TYPE;
import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import org.apache.commons.io.LineIterator;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class SourceDataInterpretator {

    private static final String CHAPTER_HTML_PARAM = "chapterHTML";
    private static final String TESTAMENT_PARAM = "testament";
    private static final String TOME_PARAM = "tome";
    private static final String CHAPTER_PARAM = "chapter";
    private boolean unfinishedPericopeFlag;
    private boolean loadSupplementIndexes;

    protected SourceDataInterpretator() {
        this(true);
    }

    protected SourceDataInterpretator(boolean loadSupplementIndexes) {
        this.loadSupplementIndexes = loadSupplementIndexes;
        this.unfinishedPericopeFlag = false;
    }

    protected SourceDataInterpretator setLoadSupplementIndexes(boolean loadSupplementIndexes) {
        this.loadSupplementIndexes = loadSupplementIndexes;
        return this;
    }

    protected Bible interpret(MetadataCollector metadataCollector, LineIterator iterator) {
        Bible bible = Bible.getInstance();
        String container = SourceDataConstants.BLANK;
        boolean toFlush = false;

        while (iterator.hasNext()) {
            String dataLine = iterator.nextLine().trim();
            boolean isFullLine = dataLine.endsWith(SourceDataConstants.DATA_ROOT_TAG_END);
            if (!isFullLine) {
                toFlush = true;
                container = container.trim() + SourceDataConstants.SPACE + dataLine;
            } else if (toFlush) {
                toFlush = false;
                dataLine = container.trim() + SourceDataConstants.SPACE + dataLine;
                container = SourceDataConstants.BLANK;
            }

            if (toFlush) continue;

            Map<String, String> parameters = this.getParameters(dataLine);
            this.interpretChapter(bible, metadataCollector, parameters.get(CHAPTER_HTML_PARAM), parameters.get(TESTAMENT_PARAM), parameters.get(TOME_PARAM), parameters.get(CHAPTER_PARAM));
        }
        return bible;
    }

    private void interpretChapter(Bible bible, MetadataCollector metadataCollector, String chapterHTML, String testamentID, String tomeSiglum, String chapterRelCardNum) {
        Testament testament = bible.getTestament((testamentID.equals("1") ? TESTAMENT_ID.OLD : TESTAMENT_ID.NEW));
        Tome tome = bible.loadTome((TOME_ID) BibleConstants.TOME_SIGLA_MAP.getKey(tomeSiglum));
        Chapter chapter = (chapterRelCardNum.equalsIgnoreCase(SourceDataConstants.EXCEPTIONAL_TOME_FIRST_CHAPTER)) ?
                bible.createExceptionalChapter() : bible.loadChapter(tome.getTomeId(), Integer.parseInt(chapterRelCardNum));

        Document chapterDOC = Jsoup.parseBodyFragment(chapterHTML);
        this.loadVerses(bible, chapter, chapterDOC);
        this.loadPericopes(bible, metadataCollector, tome, chapter, chapterDOC);
        this.loadSupplements(bible, chapterDOC, SUPPLEMENT_TYPE.DEF);
        this.loadSupplements(bible, chapterDOC, SUPPLEMENT_TYPE.DICT);
        if (loadSupplementIndexes) {
            this.fillSupplementIndexes(tome, metadataCollector, chapter, chapterDOC, SUPPLEMENT_TYPE.DEF);
            this.fillSupplementIndexes(tome, metadataCollector, chapter, chapterDOC, SUPPLEMENT_TYPE.DICT);
        }

        tome.addChapter(chapter);
        testament.addTome(tome);
    }

    private void loadVerses(Bible bible, Chapter chapter, Document chapterDOC) {
        Elements verseBoxStartPoints = chapterDOC.getElementsByClass(SourceDataConstants.VRS_LOC_START);
        for (Element verseBoxStartPoint : verseBoxStartPoints) {
            Element verseRelCardNumContainer = verseBoxStartPoint.nextElementSibling();
            String verseSiglum = verseRelCardNumContainer.text();
            StringBuilder verseContentBuilder = new StringBuilder(SourceDataConstants.BLANK);

            Elements verseRelCardNumContainerSiblings = verseRelCardNumContainer.nextElementSiblings();
            Iterator<Element> siblingsIterator = verseRelCardNumContainerSiblings.iterator();
            Element nextSibling = siblingsIterator.next();
            String nextSiblingClassName = nextSibling.className();
            while (!nextSiblingClassName.contains(SourceDataConstants.VRS_LOC_END)) {
                boolean isSpan = nextSibling.tagName().equalsIgnoreCase(SourceDataConstants.SPAN_TAG);
                boolean hasVerseClass = nextSiblingClassName.equalsIgnoreCase(SourceDataConstants.VERSE_CLASS);
                if (isSpan && hasVerseClass) {
                    String verseContentPart = nextSibling.text();
                    verseContentBuilder.append("\n").append(verseContentPart);
                }

                nextSibling = siblingsIterator.next();
                nextSiblingClassName = nextSibling.className();
            }
            Verse verse = bible.createNewVerse(chapter.getTomeId(), chapter.getRelativeCardinalNumber(), verseSiglum);
            verse.setContent(verseContentBuilder.toString().trim());
            chapter.addVerse(verse);
        }
    }

    private void loadPericopes(Bible bible, MetadataCollector metadataCollector, Tome tome, Chapter chapter, Document chapterDOC) {
        boolean isChapterLastOne = metadataCollector.isChapterLastOne(tome.getTomeId(), chapter.getRelativeCardinalNumber());
        Elements pericopeBoxes = chapterDOC.getElementsByClass(SourceDataConstants.PERICOPE_CLASS);

        if (unfinishedPericopeFlag) {
            Pericope lastPericope = tome.getLastPericope();
            if (pericopeBoxes.size() == 0) {
                lastPericope.setLastVerseCardinalNumber(chapter.getLastVerse().getAbsoluteCardinalNumber());
                if (isChapterLastOne) unfinishedPericopeFlag = false;
            } else {
                Element firstElement = chapterDOC.getElementsByClass(SourceDataConstants.CHAPTER_CLASS).get(0);
                boolean perIsFirst = false;
                for (Element nextSibling : firstElement.nextElementSiblings()) {
                    String className = nextSibling.className();
                    if (className.contains(SourceDataConstants.PERICOPE_CLASS) || className.contains(SourceDataConstants.VRS_LOC_START)) {
                        perIsFirst = className.contains(SourceDataConstants.PERICOPE_CLASS);
                        break;
                    }
                }

                if (!perIsFirst) {
                    int lastVerse = this.getPericopeLastVerse(chapter, firstElement, -1);
                    lastPericope.setLastVerseCardinalNumber(lastVerse);
                }

                unfinishedPericopeFlag = false;
            }
        }

        for (Element pericopeBox : pericopeBoxes) {
            String pericopeName = pericopeBox.text().trim();
            Element pericopeFirstElement = pericopeBox.nextElementSibling();
            int firstVerse = this.getPericopeFirstVerse(chapter, pericopeBox, pericopeFirstElement);
            int lastVerse = this.getPericopeLastVerse(chapter, pericopeBox, firstVerse);

            if (lastVerse == -1) continue;
            if (!isChapterLastOne && chapter.getLastVerse().getAbsoluteCardinalNumber() == lastVerse)
                unfinishedPericopeFlag = true;

            Pericope pericope = bible.createNewPericope(tome.getTomeId());
            pericope.setName(pericopeName);
            pericope.setFirstVerseCardinalNumber(firstVerse);
            pericope.setLastVerseCardinalNumber(lastVerse);

            tome.addPericope(pericope);
        }
    }

    private void loadSupplements(Bible bible, Document chapterDOC, SUPPLEMENT_TYPE supplementType) {
        String supplementHtmlClass = (supplementType == SUPPLEMENT_TYPE.DEF) ? SourceDataConstants.DEFINITION_ENTRY_CLASSNAME : SourceDataConstants.DICTIONARY_ENTRY_CLASSNAME;
        Elements supplementBoxes = chapterDOC.getElementsByClass(supplementHtmlClass);
        for (Element supplementBox : supplementBoxes) {
            boolean isDiv = supplementBox.tagName().equalsIgnoreCase(SourceDataConstants.DIV_TAG);
            if (!isDiv) continue;

            String suppId = supplementBox.attributes().get(SourceDataConstants.ID_ATTR);
            suppId = (supplementType == SUPPLEMENT_TYPE.DEF) ?
                    suppId.replace(SourceDataConstants.DEFINITION_ID_PREFIX, SourceDataConstants.BLANK) :
                    suppId.replace(SourceDataConstants.DICTIONARY_ID_PREFIX, SourceDataConstants.BLANK);


            supplementBox = this.getRealSupplementElement(supplementBox);
            Element suppContentElement = supplementBox.children().get(1);
            String suppContent = suppContentElement.text().trim();

            if (supplementType == SUPPLEMENT_TYPE.DICT) {
                String definiendum = supplementBox.children().get(0).text().toUpperCase().trim();
                suppContent = definiendum + SourceDataConstants.DICTIONARY_DEFINIENS_SEPARATOR + suppContent;
            }

            Supplement supplement = bible.createNewSupplement(supplementType);
            supplement.setId(Integer.parseInt(suppId));
            supplement.setContent(suppContent);
            bible.addSupplement(supplementType, supplement);
        }
    }

    private void fillSupplementIndexes(Tome tome, MetadataCollector metadataCollector, Chapter chapter, Document chapterDOC, SUPPLEMENT_TYPE supplementType) {
        String supplementIdPrefix = (supplementType == SUPPLEMENT_TYPE.DEF) ? SourceDataConstants.DEFINITION_ID_PREFIX : SourceDataConstants.DICTIONARY_ID_PREFIX;

        Elements targetElements = chapterDOC.getElementsByTag(SourceDataConstants.A_TAG);
        for (Element targetElement : targetElements) {
            String rawSupplementId = targetElement.attr(SourceDataConstants.SUPP_DATA_TARGET_ID_ATTR);
            if (!rawSupplementId.contains(supplementIdPrefix)) continue;
            int supplementId = Integer.parseInt(rawSupplementId.replace(supplementIdPrefix, SourceDataConstants.BLANK));

            Elements targetElementPreviousSiblings = targetElement.parent().previousElementSiblings();
            String verseSiglum = SourceDataConstants.BLANK;
            for (Element targetElementPreviousSibling : targetElementPreviousSiblings) {
                boolean isSup = targetElementPreviousSibling.tagName().equalsIgnoreCase(SourceDataConstants.SUP_TAG);
                if (isSup) {
                    verseSiglum = targetElementPreviousSibling.text().trim();
                    break;
                }
            }
            if (verseSiglum.equals(SourceDataConstants.BLANK)) verseSiglum = "1";

            int verseAbsCardNum = chapter.getVerseAbsCardNum(verseSiglum);
            Pericope pericopeWithVerse = tome.findPericopeWithVerse(verseAbsCardNum);
            int pericopeAbsCardNum = -1;
            if (pericopeWithVerse != null) pericopeAbsCardNum = pericopeWithVerse.getAbsoluteCardinalNumber();
            int chapterAbsCardNum = chapter.getAbsoluteCardinalNumber();
            int tomeAbsCardNum = tome.getAbsoluteCardinalNumber();
            metadataCollector.addSupplementIndex(supplementType, supplementId, verseAbsCardNum, pericopeAbsCardNum, chapterAbsCardNum, tomeAbsCardNum);
        }
    }

    private int getPericopeFirstVerse(Chapter chapter, Element pericopeBox, Element pericopeFirstElement) {
        boolean isSpan = pericopeFirstElement.tagName().equalsIgnoreCase(SourceDataConstants.SPAN_TAG);
        boolean hasVerseClass = pericopeFirstElement.className().equalsIgnoreCase(SourceDataConstants.VERSE_CLASS);

        // if pericope starts in a half of a verse
        if (isSpan && hasVerseClass) {
            Elements pericopePreviousSiblings = pericopeBox.previousElementSiblings();
            for (Element previousSibling : pericopePreviousSiblings) {
                boolean isSup = previousSibling.tagName().equalsIgnoreCase(SourceDataConstants.SUP_TAG);
                if (isSup) {
                    String verseSiglum = previousSibling.text();
                    int verseAbsCardNum = chapter.getVerseAbsCardNum(verseSiglum);
                    if (verseAbsCardNum > 0) return verseAbsCardNum;
                }
            }
            // if pericope starts with a verse start
        } else {
            Elements pericopeNextSiblings = pericopeBox.nextElementSiblings();
            for (Element nextSibling : pericopeNextSiblings) {
                boolean isVerseStartPoint = nextSibling.className().contains(SourceDataConstants.VRS_LOC_START);
                if (isVerseStartPoint) {
                    String verseSiglum = nextSibling.nextElementSibling().text();
                    int verseAbsCardNum = chapter.getVerseAbsCardNum(verseSiglum);
                    if (verseAbsCardNum > 0) return verseAbsCardNum;
                }
            }
        }

        return -1;
    }

    private int getPericopeLastVerse(Chapter chapter, Element pericopeBox, int currPericopeFirstVerse) {
        int lastVerseAbsNum = -1;
        boolean hasVerses = false;
        boolean hasVerseStartPoint = false;
        for (Element nextSibling : pericopeBox.nextElementSiblings()) {
            String elementClass = nextSibling.className();
            if (elementClass.contains(SourceDataConstants.PERICOPE_CLASS)) break;

            boolean isVerseStartPoint = elementClass.contains(SourceDataConstants.VRS_LOC_START);
            if (!hasVerses && elementClass.contains(SourceDataConstants.VERSE_CLASS)) hasVerses = true;
            if (!hasVerseStartPoint && isVerseStartPoint) hasVerseStartPoint = true;

            if (isVerseStartPoint) {
                String verseSiglum = nextSibling.nextElementSibling().text();
                int verseAbsCardNum = chapter.getVerseAbsCardNum(verseSiglum);
                if (verseAbsCardNum > 0) lastVerseAbsNum = verseAbsCardNum;
            }
        }
        if (!hasVerses) return -1;
        else if (!hasVerseStartPoint) return currPericopeFirstVerse;
        else return lastVerseAbsNum;
    }

    private Element getRealSupplementElement(Element supplementBox) {
        Elements suppBoxChildren = supplementBox.children();
        return (suppBoxChildren.size() == 1) ? suppBoxChildren.get(0) : supplementBox;
    }

    private Map<String, String> getParameters(String data) {
        Map<String, String> parameters = new HashMap<>();
        String[] dataParts = data.split(SourceDataConstants.DATA_SEPARATOR);
        String[] siglaParts = dataParts[0].split(SourceDataConstants.SIGLA_SEPARATOR);
        parameters.put(CHAPTER_HTML_PARAM, dataParts[1]);
        parameters.put(TESTAMENT_PARAM, siglaParts[0]);
        parameters.put(TOME_PARAM, siglaParts[1]);
        parameters.put(CHAPTER_PARAM, siglaParts[2]);

        return parameters;
    }
}
