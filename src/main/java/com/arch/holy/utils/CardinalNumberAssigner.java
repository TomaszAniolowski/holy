package com.arch.holy.utils;

public class CardinalNumberAssigner {

    private int nextChapterCardNumber;
    private int nextPericopeCardNumber;
    private int nextVerseCardNumber;

    private CardinalNumberAssigner() {
        this.nextChapterCardNumber = 0;
        this.nextPericopeCardNumber = 0;
        this.nextVerseCardNumber = 0;
    }

    public static CardinalNumberAssigner getNewAssigner() {
        return new CardinalNumberAssigner();
    }

    public int getNextChapterCardNumber() {
        return ++nextChapterCardNumber;
    }

    public int getNextPericopeCardNumber() {
        return ++nextPericopeCardNumber;
    }

    public int getNextVerseCardNumber() {
        return ++nextVerseCardNumber;
    }

    public int getLastChapterCardNumber() {
        return nextChapterCardNumber;
    }

    public int getLastPericopeCardNumber() {
        return nextPericopeCardNumber;
    }

    public int getLastVerseCardNumber() {
        return nextVerseCardNumber;
    }

    public int getPreviousChapterCardNumber() {
        return nextChapterCardNumber - 1;
    }

    public int getPreviousPericopeCardNumber() {
        return nextPericopeCardNumber - 1;
    }

    public int getPreviousVerseCardNumber() {
        return nextVerseCardNumber - 1;
    }
}
