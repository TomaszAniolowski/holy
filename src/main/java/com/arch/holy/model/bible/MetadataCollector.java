package com.arch.holy.model.bible;

import com.arch.holy.model.enums.SUPPLEMENT_TYPE;
import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;

import java.util.*;

public class MetadataCollector {

    private UUID id;

    private Map<Integer, Integer> verseToPericope;
    private Map<Integer, Integer> verseToChapter;
    private Map<Integer, TOME_ID> verseToTome;
    private Map<Integer, TOME_ID> pericopeToTome;
    private Map<Integer, TESTAMENT_ID> pericopeToTestament;
    private Map<Integer, TOME_ID> chapterToTome;
    private Map<Integer, TESTAMENT_ID> chapterToTestament;
    private Map<Integer, Set<Integer>> defToVersesMap;
    private Map<Integer, Set<Integer>> defToPericopesMap;
    private Map<Integer, Set<Integer>> defToChaptersMap;
    private Map<Integer, Set<Integer>> defToTomesMap;
    private Map<Integer, Set<Integer>> verseToDefMap;
    private Map<Integer, Set<Integer>> pericopesToDefMap;
    private Map<Integer, Set<Integer>> chapterToDefMap;
    private Map<Integer, Set<Integer>> tomeToDefMap;
    private Map<Integer, Set<Integer>> dictToVersesMap;
    private Map<Integer, Set<Integer>> dictToPericopesMap;
    private Map<Integer, Set<Integer>> dictToChaptersMap;
    private Map<Integer, Set<Integer>> dictToTomesMap;
    private Map<Integer, Set<Integer>> verseToDictMap;
    private Map<Integer, Set<Integer>> pericopesToDictMap;
    private Map<Integer, Set<Integer>> chapterToDictMap;
    private Map<Integer, Set<Integer>> tomeToDictMap;

    protected MetadataCollector() {
        id = UUID.randomUUID();
        verseToPericope = new TreeMap<>();
        verseToChapter = new TreeMap<>();
        verseToTome = new TreeMap<>();
        pericopeToTome = new TreeMap<>();
        pericopeToTestament = new TreeMap<>();
        chapterToTome = new TreeMap<>();
        chapterToTestament = new TreeMap<>();
        defToVersesMap = new TreeMap<>();
        defToPericopesMap = new TreeMap<>();
        defToChaptersMap = new TreeMap<>();
        defToTomesMap = new TreeMap<>();
        verseToDefMap = new TreeMap<>();
        pericopesToDefMap = new TreeMap<>();
        chapterToDefMap = new TreeMap<>();
        tomeToDefMap = new TreeMap<>();
        dictToVersesMap = new TreeMap<>();
        dictToPericopesMap = new TreeMap<>();
        dictToChaptersMap = new TreeMap<>();
        dictToTomesMap = new TreeMap<>();
        verseToDictMap = new TreeMap<>();
        pericopesToDictMap = new TreeMap<>();
        chapterToDictMap = new TreeMap<>();
        tomeToDictMap = new TreeMap<>();
    }

    public UUID getId() {
        return id;
    }

    public Map<Integer, Integer> getVerseToPericope() {
        return verseToPericope;
    }

    public Map<Integer, Integer> getVerseToChapter() {
        return verseToChapter;
    }

    public Map<Integer, TOME_ID> getVerseToTome() {
        return verseToTome;
    }

    public Map<Integer, TOME_ID> getPericopeToTome() {
        return pericopeToTome;
    }

    public Map<Integer, TESTAMENT_ID> getPericopeToTestament() {
        return pericopeToTestament;
    }

    public Map<Integer, TOME_ID> getChapterToTome() {
        return chapterToTome;
    }

    public Map<Integer, TESTAMENT_ID> getChapterToTestament() {
        return chapterToTestament;
    }

    public Map<Integer, Set<Integer>> getDefToVersesMap() {
        return defToVersesMap;
    }

    public Map<Integer, Set<Integer>> getDefToPericopesMap() {
        return defToPericopesMap;
    }

    public Map<Integer, Set<Integer>> getDefToChaptersMap() {
        return defToChaptersMap;
    }

    public Map<Integer, Set<Integer>> getDefToTomesMap() {
        return defToTomesMap;
    }

    public Map<Integer, Set<Integer>> getVerseToDefMap() {
        return verseToDefMap;
    }

    public Map<Integer, Set<Integer>> getPericopesToDefMap() {
        return pericopesToDefMap;
    }

    public Map<Integer, Set<Integer>> getChapterToDefMap() {
        return chapterToDefMap;
    }

    public Map<Integer, Set<Integer>> getTomeToDefMap() {
        return tomeToDefMap;
    }

    public Map<Integer, Set<Integer>> getDictToVersesMap() {
        return dictToVersesMap;
    }

    public Map<Integer, Set<Integer>> getDictToPericopesMap() {
        return dictToPericopesMap;
    }

    public Map<Integer, Set<Integer>> getDictToChaptersMap() {
        return dictToChaptersMap;
    }

    public Map<Integer, Set<Integer>> getDictToTomesMap() {
        return dictToTomesMap;
    }

    public Map<Integer, Set<Integer>> getVerseToDictMap() {
        return verseToDictMap;
    }

    public Map<Integer, Set<Integer>> getPericopesToDictMap() {
        return pericopesToDictMap;
    }

    public Map<Integer, Set<Integer>> getChapterToDictMap() {
        return chapterToDictMap;
    }

    public Map<Integer, Set<Integer>> getTomeToDictMap() {
        return tomeToDictMap;
    }

    public TreeMap<String, String> getTomeLastChaptersMap() {
        TreeMap<String, String> tomeLastChaptersMap = new TreeMap<>(
                (siglum1, siglum2) -> {
                    int firstTomeId = (int) BibleConstants.TOME_ORDER_MAP.getKey(BibleConstants.TOME_SIGLA_MAP.getKey(siglum1));
                    int secondTomeId = (int) BibleConstants.TOME_ORDER_MAP.getKey(BibleConstants.TOME_SIGLA_MAP.getKey(siglum2));
                    return Integer.compare(firstTomeId, secondTomeId);
                }
        );

        for (Object tomeId : BibleConstants.TOME_ORDER_MAP.values()) {
            TOME_ID tome = (TOME_ID) tomeId;
            String siglum = (String) BibleConstants.TOME_SIGLA_MAP.get(tome);
            String lastChapter = BibleConstants.TOME_LAST_CHAPTER_MAP.get(tome);
            tomeLastChaptersMap.put(siglum, lastChapter);
        }

        return tomeLastChaptersMap;
    }
    
    public TESTAMENT_ID findTestamentIdForTome(TOME_ID tomeId){
        return (BibleConstants.OLD_TESTAMENT_TOMES.contains(tomeId)) ? TESTAMENT_ID.OLD : TESTAMENT_ID.NEW;
    }

    public String getTomeSiglum(TOME_ID tomeId){
        return (String) BibleConstants.TOME_SIGLA_MAP.get(tomeId);
    }

    public int getTomeCardinalNumber(String siglum){
        return this.getTomeCardinalNumber((TOME_ID) BibleConstants.TOME_SIGLA_MAP.getKey(siglum));
    }

    public int getTomeCardinalNumber(TOME_ID tomeId){
        return (int) BibleConstants.TOME_ORDER_MAP.getKey(tomeId);
    }
    
    public boolean isChapterFirstOne(TOME_ID tomeId, int chapter){
        return BibleConstants.TOME_FIRST_CHAPTER_MAP.get(tomeId).equals(String.valueOf(chapter));
    }

    public boolean isChapterLastOne(TOME_ID tomeId, int chapter){
        return BibleConstants.TOME_LAST_CHAPTER_MAP.get(tomeId).equals(String.valueOf(chapter));
    }

    public String getTomeFirstChapter(TOME_ID tomeId){
        return BibleConstants.TOME_FIRST_CHAPTER_MAP.get(tomeId);
    }

    public String getTomeLastChapter(TOME_ID tomeId){
        return BibleConstants.TOME_LAST_CHAPTER_MAP.get(tomeId);
    }

    public int getTestamentFirstVerse(TESTAMENT_ID testamentId) {
        return (testamentId == TESTAMENT_ID.OLD) ? BibleConstants.OLD_T_VERSE_CARD_NUM_RANGE_START : BibleConstants.NEW_T_VERSE_CARD_NUM_RANGE_START;
    }

    public int getTestamentLastVerse(TESTAMENT_ID testamentId) {
        return (testamentId == TESTAMENT_ID.OLD) ? BibleConstants.OLD_T_VERSE_CARD_NUM_RANGE_END : BibleConstants.NEW_T_VERSE_CARD_NUM_RANGE_END;
    }
    
    public void addSupplementIndex(SUPPLEMENT_TYPE type, int supplementId, int verseAbsCardNum, int pericopeAbsCardNum, int chapterAbsCardNum, int tomeAbsCardNum){
        Map<Integer, Set<Integer>> suppToVerseMap = (type == SUPPLEMENT_TYPE.DEF) ? defToVersesMap : dictToVersesMap;
        Map<Integer, Set<Integer>> suppToPericopesMap = (type == SUPPLEMENT_TYPE.DEF) ? defToPericopesMap : dictToPericopesMap;
        Map<Integer, Set<Integer>> suppToChaptersMap = (type == SUPPLEMENT_TYPE.DEF) ? defToChaptersMap : dictToChaptersMap;
        Map<Integer, Set<Integer>> suppToTomesMap = (type == SUPPLEMENT_TYPE.DEF) ? defToTomesMap : dictToTomesMap;
        Map<Integer, Set<Integer>> verseToSuppMap = (type == SUPPLEMENT_TYPE.DEF) ? verseToDefMap : verseToDictMap;
        Map<Integer, Set<Integer>> pericopesToSuppMap = (type == SUPPLEMENT_TYPE.DEF) ? pericopesToDefMap : pericopesToDictMap;
        Map<Integer, Set<Integer>> chapterToSuppMap = (type == SUPPLEMENT_TYPE.DEF) ? chapterToDefMap : chapterToDictMap;
        Map<Integer, Set<Integer>> tomeToSuppMap = (type == SUPPLEMENT_TYPE.DEF) ? tomeToDefMap : tomeToDictMap;
        addNewSuppIndexEntry(suppToVerseMap, supplementId, verseAbsCardNum);
        if (pericopeAbsCardNum != -1) addNewSuppIndexEntry(suppToPericopesMap, supplementId, pericopeAbsCardNum);
        addNewSuppIndexEntry(suppToChaptersMap, supplementId, chapterAbsCardNum);
        addNewSuppIndexEntry(suppToTomesMap, supplementId, tomeAbsCardNum);
        addNewSuppIndexEntry(verseToSuppMap, verseAbsCardNum, supplementId);
        if (pericopeAbsCardNum != -1) addNewSuppIndexEntry(pericopesToSuppMap,pericopeAbsCardNum, supplementId);
        addNewSuppIndexEntry(chapterToSuppMap, chapterAbsCardNum, supplementId);
        addNewSuppIndexEntry(tomeToSuppMap, tomeAbsCardNum, supplementId);
    }

    private void addNewSuppIndexEntry(Map<Integer, Set<Integer>> indexMap, int key, int value) {
        Optional<Set<Integer>> set = indexMap.entrySet().stream().filter(i -> i.getKey().equals(key)).map(Map.Entry::getValue).findFirst();
        if (set.isEmpty()) {
            Set<Integer> newSet = new HashSet<>();
            newSet.add(value);
            indexMap.put(key, newSet);
        } else {
            set.get().add(value);
        }

    }

    public void addNewVerseToPericopeEntry(int key, int value){
        verseToPericope.put(key, value);
    }
    public void addNewVerseToChapterEntry(int key, int value){
        verseToChapter.put(key, value);
    }
    public void addNewVerseToTomeEntry(int key, TOME_ID value){
        verseToTome.put(key, value);
    }
    public void addNewPericopeToTomeEntry(int key, TOME_ID value){
        pericopeToTome.put(key, value);
    }
    public void addNewPericopeToTestamentEntry(int key, TESTAMENT_ID value){
        pericopeToTestament.put(key, value);
    }
    public void addNewChapterToTomeEntry(int key, TOME_ID value){
        chapterToTome.put(key, value);
    }
    public void addNewChapterToTestamentEntry(int key, TESTAMENT_ID value){
        chapterToTestament.put(key, value);
    }
}
