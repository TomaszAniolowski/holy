package com.arch.holy.model.bible;

import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import com.arch.holy.management.SourceDataConstants;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

public class Verse implements Comparable<Verse>{

    private TESTAMENT_ID testamentId;
    private TOME_ID tomeId;
    private int chapterRelativeCardinalNumber;
    private String siglum;
    private int absoluteCardinalNumber;
    private String content;

    private Verse() {
    }

    public Verse(TOME_ID tomeId, int chapterRelativeCardinalNumber, int absoluteCardinalNumber, String siglum) {
        this(tomeId, chapterRelativeCardinalNumber, siglum, absoluteCardinalNumber, SourceDataConstants.BLANK);
    }

    public Verse(TOME_ID tomeId, int chapterRelativeCardinalNumber, String siglum, int absoluteCardinalNumber, String content) {
        this.testamentId = BibleConstants.OLD_TESTAMENT_TOMES.contains(tomeId) ? TESTAMENT_ID.OLD : TESTAMENT_ID.NEW;
        this.tomeId = tomeId;
        this.chapterRelativeCardinalNumber = chapterRelativeCardinalNumber;
        this.siglum = siglum;
        this.absoluteCardinalNumber = absoluteCardinalNumber;
        this.content = content;
    }

    public String getSiglum() {
        return siglum;
    }

    public Verse setSiglum(String siglum) {
        this.siglum = siglum;
        return this;
    }

    public int getAbsoluteCardinalNumber() {
        return absoluteCardinalNumber;
    }

    public TESTAMENT_ID getTestamentId() {
        return testamentId;
    }

    protected Verse setTestamentId(TESTAMENT_ID testamentId) {
        this.testamentId = testamentId;
        return this;
    }

    public TOME_ID getTomeId() {
        return tomeId;
    }

    protected Verse setTomeId(TOME_ID tomeId) {
        this.tomeId = tomeId;
        return this;
    }

    public int getChapterRelativeCardinalNumber() {
        return chapterRelativeCardinalNumber;
    }

    protected Verse setChapterRelativeCardinalNumber(int chapterRelativeCardinalNumber) {
        this.chapterRelativeCardinalNumber = chapterRelativeCardinalNumber;
        return this;
    }

    public String getContent() {
        return content;
    }

    public Verse setContent(String content) {
        this.content = content;
        return this;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass()) return false;

        Verse verse = (Verse) o;

        return new EqualsBuilder()
                .append(siglum, verse.siglum)
                .append(chapterRelativeCardinalNumber, verse.chapterRelativeCardinalNumber)
                .append(tomeId, verse.tomeId)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(siglum)
                .append(chapterRelativeCardinalNumber)
                .append(tomeId)
                .toHashCode();
    }

    @Override
    public String toString() {
        return BibleConstants.TOME_SIGLA_MAP.get(tomeId) + SourceDataConstants.SPACE + chapterRelativeCardinalNumber + SourceDataConstants.COMMA_WITH_SPACE + siglum;
    }

    @Override
    public int compareTo(Verse other) {
        return Integer.compare(this.getAbsoluteCardinalNumber(), other.getAbsoluteCardinalNumber());
    }
}
