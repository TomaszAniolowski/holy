package com.arch.holy.model.bible;

import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Chapter extends VerseConatainer implements Comparable<Chapter> {

    private TESTAMENT_ID testamentId;
    private TOME_ID tomeId;
    private int relativeCardinalNumber;
    private int absoluteCardinalNumber;
    private List<Verse> verses;

    private Chapter() {
    }

    public Chapter(TOME_ID tomeId, int relativeCardinalNumber, int absoluteCardinalNumber) {
        this(tomeId, relativeCardinalNumber, absoluteCardinalNumber, new ArrayList<>());
    }

    public Chapter(TOME_ID tomeId, int relativeCardinalNumber, int absoluteCardinalNumber, List<Verse> verses) {
        this.testamentId = BibleConstants.OLD_TESTAMENT_TOMES.contains(tomeId) ? TESTAMENT_ID.OLD : TESTAMENT_ID.NEW;
        this.tomeId = tomeId;
        this.relativeCardinalNumber = relativeCardinalNumber;
        this.absoluteCardinalNumber = absoluteCardinalNumber;
        this.verses = verses;
    }

    public int getRelativeCardinalNumber() {
        return relativeCardinalNumber;
    }

    public Chapter setRelativeCardinalNumber(int relativeCardinalNumber) {
        this.relativeCardinalNumber = relativeCardinalNumber;
        return this;
    }

    public int getAbsoluteCardinalNumber() {
        return absoluteCardinalNumber;
    }

    public TESTAMENT_ID getTestamentId() {
        return testamentId;
    }

    protected Chapter setTestamentId(TESTAMENT_ID testamentId) {
        this.testamentId = testamentId;
        return this;
    }

    public TOME_ID getTomeId() {
        return tomeId;
    }

    protected Chapter setTomeId(TOME_ID tomeId) {
        this.tomeId = tomeId;
        return this;
    }

    @Override
    public List<Verse> getVerses() {
        return verses;
    }

    public Chapter setVerses(List<Verse> verses) {
        this.verses = verses;
        return this;
    }

    public boolean addVerse(Verse verse) {
        if (!verse.getContent().isBlank() && !verses.contains(verse)) {
            verses.add(verse);
            Collections.sort(verses);
            return true;
        }
        return false;
    }

    public Verse getVerse(String siglum) {
        return verses.stream().filter(ch -> ch.getSiglum().equals(siglum)).findFirst().orElse(null);
    }

    public Verse getFirstVerse(){
        return verses.get(0);
    }

    public Verse getLastVerse(){
        return verses.get(verses.size() - 1);
    }

    @Override
    public Verse findVerse(int absoluteCardinalNumber){
        return verses.stream().filter(ch -> ch.getAbsoluteCardinalNumber() == absoluteCardinalNumber).findFirst().orElse(null);
    }

    public int getVerseAbsCardNum(String siglum){
        Verse verse = this.getVerse(siglum);
        return (verse == null) ? -1 : verse.getAbsoluteCardinalNumber();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass()) return false;

        Chapter chapter = (Chapter) o;

        return new EqualsBuilder()
                .append(relativeCardinalNumber, chapter.relativeCardinalNumber)
                .append(tomeId, chapter.tomeId)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(relativeCardinalNumber)
                .append(tomeId)
                .toHashCode();
    }

    @Override
    public String toString() {
        String chapter = relativeCardinalNumber == 0 ? "Prolog" : String.valueOf(relativeCardinalNumber);
        return BibleConstants.TOME_SIGLA_MAP.get(tomeId) + " " + chapter;
    }

    @Override
    public int compareTo(Chapter other) {
        return Integer.compare(this.getAbsoluteCardinalNumber(), other.getAbsoluteCardinalNumber());
    }
}
