package com.arch.holy.model.bible;

import com.arch.holy.model.enums.TOME_ID;

import java.util.List;

public abstract class TomeContainer extends ChapterContainer {

    public abstract Tome findTome(int absoluteCardinalNumber);

    public abstract List<Tome> getTomes();

    public abstract Verse findVerse(TOME_ID tomeId, int chapterRelativeCardinalNumber, String verseSiglum);

    public int getTomeRelCardNum(int absoluteCardinalNumber){
        return this.findTome(absoluteCardinalNumber).getRelativeCardinalNumber();
    }
}
