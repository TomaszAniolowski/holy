package com.arch.holy.model.bible;

import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import com.arch.holy.utils.CardinalNumberAssigner;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class Tome extends ChapterContainer implements Comparable<Tome> {

    private CardinalNumberAssigner relativeAssigner;
    private TESTAMENT_ID testamentId;
    private TOME_ID tomeId;
    private int relativeCardinalNumber;
    private int absoluteCardinalNumber;
    private String tomeSiglum;
    private String name;
    private List<Chapter> chapters;
    private List<Pericope> pericopes;

    private Tome() {
    }

    public Tome(TOME_ID tomeId) {
        this(tomeId, new ArrayList<>(), new ArrayList<>());
    }

    public Tome(TOME_ID tomeId, List<Chapter> chapters, List<Pericope> pericopes) {
        this.relativeAssigner = CardinalNumberAssigner.getNewAssigner();
        this.testamentId = BibleConstants.OLD_TESTAMENT_TOMES.contains(tomeId) ? TESTAMENT_ID.OLD : TESTAMENT_ID.NEW;
        this.tomeId = tomeId;
        this.relativeCardinalNumber = (BibleConstants.OLD_TESTAMENT_TOMES.contains(tomeId)) ? absoluteCardinalNumber : absoluteCardinalNumber - BibleConstants.OLD_T_TOME_CARD_NUM_RANGE_END;
        this.absoluteCardinalNumber = (int) BibleConstants.TOME_ORDER_MAP.getKey(tomeId);
        this.tomeSiglum = (String) BibleConstants.TOME_SIGLA_MAP.get(tomeId);
        this.name = BibleConstants.TOME_NAMES_MAP.get(tomeId);
        this.chapters = chapters;
        this.pericopes = pericopes;
    }

    public int getRelativeCardinalNumber() {
        return relativeCardinalNumber;
    }

    public Tome setRelativeCardinalNumber(int relativeCardinalNumber) {
        this.relativeCardinalNumber = relativeCardinalNumber;
        return this;
    }

    public int getAbsoluteCardinalNumber() {
        return absoluteCardinalNumber;
    }

    public TESTAMENT_ID getTestamentId() {
        return testamentId;
    }

    public Tome setTestamentId(TESTAMENT_ID testamentId) {
        this.testamentId = testamentId;
        return this;
    }

    public TOME_ID getTomeId() {
        return tomeId;
    }

    public Tome setTomeId(TOME_ID tomeId) {
        this.tomeId = tomeId;
        this.tomeSiglum = (String) BibleConstants.TOME_SIGLA_MAP.get(tomeId);
        this.name = BibleConstants.TOME_NAMES_MAP.get(tomeId);
        return this;
    }

    public String getTomeSiglum() {
        return tomeSiglum;
    }

    public String getName() {
        return name;
    }

    @Override
    public List<Chapter> getChapters() {
        return chapters;
    }

    public Tome setChapters(List<Chapter> chapters) {
        this.chapters = chapters;
        return this;
    }

    @Override
    public List<Pericope> getPericopes() {
        return pericopes;
    }

    public Tome setPericopes(List<Pericope> pericopes) {
        this.pericopes = pericopes;
        return this;
    }

    public boolean addChapter(Chapter chapter) {
        if (chapter.getVerses().size() != 0 && !chapters.contains(chapter)) {
            chapters.add(chapter);
            Collections.sort(chapters);
            return true;
        }
        return false;
    }

    public Chapter getChapter(int relativeCardinalNumber) {
        return chapters.stream().filter(ch -> ch.getRelativeCardinalNumber() == relativeCardinalNumber).findFirst().orElse(null);
    }

    public boolean addPericope(Pericope pericope) {
        if (pericope.getFirstVerseCardinalNumber() != 0 && !pericope.getName().isBlank() && !pericopes.contains(pericope)) {
            pericope.setRelativeCardinalNumber(relativeAssigner.getNextPericopeCardNumber());
            pericopes.add(pericope);
            Collections.sort(pericopes);
            return true;
        }
        return false;
    }

    public Pericope getPericope(int relativeCardinalNumber) {
        return pericopes.stream().filter(ch -> ch.getRelativeCardinalNumber() == relativeCardinalNumber).findFirst().orElse(null);
    }

    public Pericope getFirstPericope() {
        return pericopes.get(0);
    }

    public Pericope getLastPericope() {
        return pericopes.get(pericopes.size() - 1);
    }

    public boolean hasPericopes() {
        return pericopes.size() != 0;
    }

    @Override
    public Chapter findChapter(int absoluteCardinalNumber) {
        return chapters.stream().filter(ch -> ch.getAbsoluteCardinalNumber() == absoluteCardinalNumber).findFirst().orElse(null);
    }

    @Override
    public Pericope findPericope(int absoluteCardinalNumber) {
        return pericopes.stream().filter(p -> p.getAbsoluteCardinalNumber() == absoluteCardinalNumber).findFirst().orElse(null);
    }

    @Override
    public Verse findVerse(int absoluteCardinalNumber) {
        Chapter chapter = chapters.stream().filter(ch -> ch.findVerse(absoluteCardinalNumber) != null).findFirst().orElse(null);
        return (chapter == null) ? null : chapter.findVerse(absoluteCardinalNumber);
    }

    public Verse findVerse(int chapterRelativeCardinalNumber, String verseSiglum) {
        Chapter chapter = this.getChapter(chapterRelativeCardinalNumber);
        return (chapter == null) ? null : chapter.getVerse(verseSiglum);
    }

    public int getChapterAbsCardNum(int relativeCardinalNumber) {
        Chapter chapter = this.getChapter(relativeCardinalNumber);
        return (chapter == null) ? -1 : chapter.getAbsoluteCardinalNumber();
    }

    public int getPericopeAbsCardNum(int relativeCardinalNumber) {
        Pericope pericope = this.getPericope(relativeCardinalNumber);
        return (pericope == null) ? -1 : pericope.getAbsoluteCardinalNumber();
    }

    @Override
    public List<Verse> getVerses() {
        return chapters.stream().flatMap(ch -> ch.getVerses().stream()).sorted().collect(Collectors.toList());
    }

    public Pericope findPericopeByFirstVerse(int verseAbsoluteCardinalNumber) {
        return pericopes.stream().filter(p -> p.getFirstVerseCardinalNumber() == verseAbsoluteCardinalNumber).findFirst().orElse(null);
    }

    public Pericope findPericopeWithVerse(int verseAbsoluteCardinalNumber) {
        return pericopes.stream().filter(p -> (verseAbsoluteCardinalNumber >= p.getFirstVerseCardinalNumber() && verseAbsoluteCardinalNumber <= p.getLastVerseCardinalNumber())).findFirst().orElseGet(() -> pericopes.stream().filter(p -> p.getLastVerseCardinalNumber() == 0).findFirst().orElse(null));
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass()) return false;

        Tome tome = (Tome) o;

        return new EqualsBuilder()
                .append(tomeId, tome.tomeId)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(tomeId)
                .toHashCode();
    }

    @Override
    public String toString() {
        return tomeSiglum;
    }

    @Override
    public int compareTo(Tome other) {
        return Integer.compare(this.getAbsoluteCardinalNumber(), other.getAbsoluteCardinalNumber());
    }
}
