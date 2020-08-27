package com.arch.holy.model.bible;

import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class Testament extends TomeContainer{

    private TESTAMENT_ID id;
    private List<Tome> tomes;

    private Testament() {
        tomes = new ArrayList<>();
    }

    protected Testament(TESTAMENT_ID id) {
        this(id, new ArrayList<>());
    }

    protected Testament(TESTAMENT_ID id, List<Tome> tomes) {
        this.id = id;
        this.tomes = tomes;
    }

    public TESTAMENT_ID getId() {
        return id;
    }

    @Override
    public List<Tome> getTomes() {
        return tomes;
    }

    public Testament setTomes(List<Tome> tomes) {
        this.tomes = tomes;
        return this;
    }

    public boolean addTome(Tome tome){
        if (tome.getChapters().size() != 0 && !tomes.contains(tome)){
            tomes.add(tome);
            Collections.sort(tomes);
            return true;
        }
        return false;
    }

    public Tome getTome(String tomeSiglum){
        return tomes.stream().filter(t -> t.getTomeSiglum().equals(tomeSiglum)).findFirst().orElse(null);
    }

    public Tome getTome(TOME_ID tomeId){
        return tomes.stream().filter(t -> t.getTomeId().equals(tomeId)).findFirst().orElse(null);
    }

    @Override
    public Tome findTome(int absoluteCardinalNumber){
        return tomes.stream().filter(t -> t.getAbsoluteCardinalNumber() == absoluteCardinalNumber).findFirst().orElse(null);
    }

    @Override
    public Chapter findChapter(int absoluteCardinalNumber){
        Tome tome = tomes.stream().filter(t -> t.findChapter(absoluteCardinalNumber) != null).findFirst().orElse(null);
        return (tome == null) ? null : tome.findChapter(absoluteCardinalNumber);
    }

    public Chapter findChapter(TOME_ID tomeId, int relativeCardinalNumber){
        Tome tome = tomes.stream().filter(t -> t.getTomeId() == tomeId).findFirst().orElse(null);
        return (tome == null) ? null : tome.getChapter(relativeCardinalNumber);
    }

    @Override
    public Pericope findPericope(int absoluteCardinalNumber){
        Tome tome = tomes.stream().filter(t -> t.findPericope(absoluteCardinalNumber) != null).findFirst().orElse(null);
        return (tome == null) ? null : tome.findPericope(absoluteCardinalNumber);
    }

    public Pericope findPericope(TOME_ID tomeId, int relativeCardinalNumber){
        Tome tome = tomes.stream().filter(t -> t.getTomeId() == tomeId).findFirst().orElse(null);
        return (tome == null) ? null : tome.getPericope(relativeCardinalNumber);
    }

    @Override
    public Verse findVerse(int absoluteCardinalNumber) {
        Tome tome = tomes.stream().filter(t -> t.findVerse(absoluteCardinalNumber) != null).findFirst().orElse(null);
        return  (tome == null) ? null : tome.findVerse(absoluteCardinalNumber);
    }

    @Override
    public Verse findVerse(TOME_ID tomeId, int chapterRelativeCardinalNumber, String verseSiglum){
        Tome tome = this.getTome(tomeId);
        return (tome == null) ? null : tome.findVerse(chapterRelativeCardinalNumber, verseSiglum);
    }

    public int getTomeAbsCardNum(TOME_ID tomeId){
        Tome tome = this.getTome(tomeId);
        return (tome == null) ? -1 : tome.getAbsoluteCardinalNumber();
    }

    @Override
    public List<Chapter> getChapters(){
        return tomes.stream().flatMap(t -> t.getChapters().stream()).sorted().collect(Collectors.toList());
    }

    @Override
    public List<Pericope> getPericopes(){
        return tomes.stream().flatMap(t -> t.getPericopes().stream()).sorted().collect(Collectors.toList());
    }

    @Override
    public List<Verse> getVerses(){
        return tomes.stream().flatMap(t -> t.getVerses().stream()).sorted().collect(Collectors.toList());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass()) return false;

        Testament testament = (Testament) o;

        return new EqualsBuilder()
                .append(id, testament.id)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(id)
                .toHashCode();
    }

    @Override
    public String toString() {
        return StringUtils.capitalize(id.name()) + " Testament";
    }
}
