package com.arch.holy.model.bible;

import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import com.arch.holy.management.SourceDataConstants;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

public class Pericope implements Comparable<Pericope>{

    private TESTAMENT_ID testamentId;
    private TOME_ID tomeId;
    private int relativeCardinalNumber;
    private int absoluteCardinalNumber;
    private int firstVerseCardinalNumber;
    private int lastVerseCardinalNumber;
    private String name;

    private Pericope() {
    }

    public Pericope(TOME_ID tomeId, int absoluteCardinalNumber) {
        this(tomeId, -1, absoluteCardinalNumber, 0, 0, SourceDataConstants.BLANK);
    }

    public Pericope(TOME_ID tomeId, int relativeCardinalNumber, int absoluteCardinalNumber, int firstVerseCardinalNumber, int lastVerseCardinalNumber, String name) {
        this.testamentId = BibleConstants.OLD_TESTAMENT_TOMES.contains(tomeId) ? TESTAMENT_ID.OLD : TESTAMENT_ID.NEW;
        this.tomeId = tomeId;
        this.relativeCardinalNumber = relativeCardinalNumber;
        this.absoluteCardinalNumber = absoluteCardinalNumber;
        this.firstVerseCardinalNumber = firstVerseCardinalNumber;
        this.lastVerseCardinalNumber = lastVerseCardinalNumber;
        this.name = name;
    }

    public int getRelativeCardinalNumber() {
        return relativeCardinalNumber;
    }

    protected Pericope setRelativeCardinalNumber(int relativeCardinalNumber) {
        this.relativeCardinalNumber = relativeCardinalNumber;
        return this;
    }

    public int getAbsoluteCardinalNumber() {
        return absoluteCardinalNumber;
    }

    public TESTAMENT_ID getTestamentId() {
        return testamentId;
    }

    protected Pericope setTestamentId(TESTAMENT_ID testamentId) {
        this.testamentId = testamentId;
        return this;
    }

    public TOME_ID getTomeId() {
        return tomeId;
    }

    protected Pericope setTomeId(TOME_ID tomeId) {
        this.tomeId = tomeId;
        return this;
    }

    public int getFirstVerseCardinalNumber() {
        return firstVerseCardinalNumber;
    }

    public Pericope setFirstVerseCardinalNumber(int firstVerseCardinalNumber) {
        this.firstVerseCardinalNumber = firstVerseCardinalNumber;
        return this;
    }

    public int getLastVerseCardinalNumber() {
        return lastVerseCardinalNumber;
    }

    public Pericope setLastVerseCardinalNumber(int lastVerseCardinalNumber) {
        this.lastVerseCardinalNumber = lastVerseCardinalNumber;
        return this;
    }

    public String getName() {
        return name;
    }

    public Pericope setName(String name) {
        this.name = name;
        return this;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass()) return false;

        Pericope pericope = (Pericope) o;

        return new EqualsBuilder()
                .append(absoluteCardinalNumber, pericope.absoluteCardinalNumber)
                .append(firstVerseCardinalNumber, pericope.firstVerseCardinalNumber)
                .append(lastVerseCardinalNumber, pericope.lastVerseCardinalNumber)
                .append(tomeId, pericope.tomeId)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(tomeId)
                .append(absoluteCardinalNumber)
                .append(firstVerseCardinalNumber)
                .append(lastVerseCardinalNumber)
                .toHashCode();
    }

    @Override
    public String toString() {
        return BibleConstants.TOME_SIGLA_MAP.get(tomeId) + ": " + name;
    }

    @Override
    public int compareTo(Pericope other) {
        return Integer.compare(this.getAbsoluteCardinalNumber(), other.getAbsoluteCardinalNumber());
    }
}
