package com.arch.holy.model.bible;

import java.util.List;

public abstract class VerseConatainer {

    public abstract Verse findVerse(int absoluteCardinalNumber);

    public abstract List<Verse> getVerses();

    public String getVerseSiglum(int absoluteCardinalNumber){
        Verse verse = this.findVerse(absoluteCardinalNumber);
        return (verse == null) ? "" : verse.getSiglum();
    }
}
