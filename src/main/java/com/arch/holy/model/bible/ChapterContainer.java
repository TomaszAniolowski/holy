package com.arch.holy.model.bible;

import java.util.List;

public abstract class ChapterContainer extends VerseConatainer{

    public abstract Chapter findChapter(int absoluteCardinalNumber);

    public abstract Pericope findPericope(int absoluteCardinalNumber);

    public abstract List<Chapter> getChapters();

    public abstract List<Pericope> getPericopes();

    public int getChapterRelCardNum(int absoluteCardinalNumber){
        Chapter chapter = this.findChapter(absoluteCardinalNumber);
        return (chapter == null) ? -1 : chapter.getRelativeCardinalNumber();
    }

    public int getPericopeRelCardNum(int absoluteCardinalNumber){
        Pericope pericope =  this.findPericope(absoluteCardinalNumber);
        return (pericope == null) ? -1 : pericope.getRelativeCardinalNumber();
    }
}
