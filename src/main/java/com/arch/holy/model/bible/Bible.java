package com.arch.holy.model.bible;

import com.arch.holy.model.enums.SUPPLEMENT_TYPE;
import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import com.arch.holy.utils.CardinalNumberAssigner;
import org.apache.commons.collections.list.TreeList;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class Bible extends TomeContainer{

    private static Bible INSTANCE;

    private CardinalNumberAssigner absoluteAssigner;
    private List<Testament> testaments;
    private List<Supplement> definitions;
    private List<Supplement> dictionary;

    private Bible() {
        absoluteAssigner = CardinalNumberAssigner.getNewAssigner();
        testaments = new TreeList(){{
            add(new Testament(TESTAMENT_ID.OLD));
            add(new Testament(TESTAMENT_ID.NEW));
        }};
        definitions = new ArrayList<>();
        dictionary = new ArrayList<>();
    }

    public static Bible getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new Bible();
        }
        return INSTANCE;
    }

    public List<Testament> getTestaments() {
        return testaments;
    }

    public List<Supplement> getDefinitions() {
        return definitions;
    }

    public List<Supplement> getDictionary() {
        return dictionary;
    }

    public Tome createNewTome(TOME_ID tomeId){
        return new Tome(tomeId);
    }

    public Chapter createNewChapter(TOME_ID tomeId, int chapterRelativeCardNum){
        return new Chapter(tomeId, chapterRelativeCardNum, absoluteAssigner.getNextChapterCardNumber());
    }

    public Chapter createExceptionalChapter(){
        return new Chapter(TOME_ID.SYR, 0, absoluteAssigner.getNextChapterCardNumber());
    }

    public Pericope createNewPericope(TOME_ID tomeId){
        return new Pericope(tomeId, absoluteAssigner.getNextPericopeCardNumber());
    }

    public Verse createNewVerse(TOME_ID tomeId, int chapterRelativeCardNum, String verseSiglum){
        return new Verse(tomeId, chapterRelativeCardNum, absoluteAssigner.getNextVerseCardNumber(), verseSiglum);
    }

    public Supplement createNewSupplement(SUPPLEMENT_TYPE type){
        return (type == SUPPLEMENT_TYPE.DEF) ? this.createNewDefinition() : this.createNewDictionaryEntry();
    }

    public Supplement createNewDefinition() {return new Supplement(SUPPLEMENT_TYPE.DEF);}

    public Supplement createNewDictionaryEntry() {return new Supplement(SUPPLEMENT_TYPE.DICT);}

    public boolean addSupplement(SUPPLEMENT_TYPE type, Supplement supplement){
        return (type == SUPPLEMENT_TYPE.DEF) ? this.addDefinition(supplement) : this.addDictionaryEntry(supplement);
    }

    public boolean addDefinition(Supplement definition){
        if (definition.getType() == SUPPLEMENT_TYPE.DEF && !definition.getContent().isBlank() && !definitions.contains(definition)){
            definitions.add(definition);
            Collections.sort(definitions);
            return true;
        }
        return false;
    }

    public boolean addDictionaryEntry(Supplement dictionaryEntry){
        if (dictionaryEntry.getType() == SUPPLEMENT_TYPE.DICT && !dictionaryEntry.getContent().isBlank() && !dictionary.contains(dictionaryEntry)){
            dictionary.add(dictionaryEntry);
            Collections.sort(dictionary);
            return true;
        }
        return false;
    }

    public Supplement getSupplement(SUPPLEMENT_TYPE type, int cardinalNumber){
        return (type == SUPPLEMENT_TYPE.DEF) ? this.getDefinition(cardinalNumber) : this.getDictionaryEntry(cardinalNumber);
    }

    public Supplement getDefinition(int cardinalNumber){
        return definitions.stream().filter(d -> d.getId() == cardinalNumber).findFirst().orElse(null);
    }

    public Supplement getDictionaryEntry(int cardinalNumber){
        return dictionary.stream().filter(d -> d.getId() == cardinalNumber).findFirst().orElse(null);
    }

    public Testament getTestament(TESTAMENT_ID testamentId){
        return testaments.stream().filter(t -> t.getId() == testamentId).findFirst().orElse(null);
    }

    @Override
    public Tome findTome(int absoluteCardinalNumber) {
        Testament testament = testaments.stream().filter(t -> t.findTome(absoluteCardinalNumber) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findTome(absoluteCardinalNumber);
    }

    public Tome findTome(TOME_ID tomeId) {
        Testament testament = testaments.stream().filter(t -> t.getTome(tomeId) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.getTome(tomeId);
    }

    @Override
    public Chapter findChapter(int absoluteCardinalNumber){
        Testament testament = testaments.stream().filter(t -> t.findChapter(absoluteCardinalNumber) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findChapter(absoluteCardinalNumber);
    }

    public Chapter findChapter(TOME_ID tomeId, int chapterRelativeCardinalNumber) {
        Testament testament = testaments.stream().filter(t -> t.getTome(tomeId) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findChapter(tomeId, chapterRelativeCardinalNumber);
    }

    @Override
    public Pericope findPericope(int absoluteCardinalNumber){
        Testament testament = testaments.stream().filter(t -> t.findPericope(absoluteCardinalNumber) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findPericope(absoluteCardinalNumber);
    }

    public Pericope findPericope(TOME_ID tomeId, int relativeCardinalNumber){
        Testament testament = testaments.stream().filter(t -> t.getTome(tomeId) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findPericope(tomeId, relativeCardinalNumber);
    }

    @Override
    public Verse findVerse(int absoluteCardinalNumber) {
        Testament testament = testaments.stream().filter(t -> t.findVerse(absoluteCardinalNumber) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findVerse(absoluteCardinalNumber);
    }

    @Override
    public Verse findVerse(TOME_ID tomeId, int chapterRelativeCardinalNumber, String verseSiglum){
        Testament testament = testaments.stream().filter(t -> t.getTome(tomeId) != null).findFirst().orElse(null);
        if (testament == null) return null;
        return testament.findVerse(tomeId, chapterRelativeCardinalNumber, verseSiglum);
    }

    @Override
    public List<Tome> getTomes(){
        return testaments.stream().flatMap(t -> t.getTomes().stream()).sorted().collect(Collectors.toList());
    }

    @Override
    public List<Chapter> getChapters(){
        return testaments.stream().flatMap(tes -> tes.getChapters().stream()).sorted().collect(Collectors.toList());
    }

    @Override
    public List<Pericope> getPericopes(){
        return testaments.stream().flatMap(tes -> tes.getPericopes().stream()).sorted().collect(Collectors.toList());
    }

    @Override
    public List<Verse> getVerses(){
        return testaments.stream().flatMap(tes -> tes.getVerses().stream()).sorted().collect(Collectors.toList());
    }

    public Tome loadTome(TOME_ID tomeId){
        Tome tome = this.findTome(tomeId);
        return tome == null ? this.createNewTome(tomeId) : tome;
    }

    public Chapter loadChapter(TOME_ID tomeId, int chapterRelativeCardinalNumber){
        Chapter chapter = this.findChapter(tomeId, chapterRelativeCardinalNumber);
        return chapter == null ? this.createNewChapter(tomeId, chapterRelativeCardinalNumber) : chapter;
    }
}
