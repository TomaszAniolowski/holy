package com.arch.holy.model.bible;

import com.arch.holy.model.enums.SUPPLEMENT_TYPE;
import com.arch.holy.management.SourceDataConstants;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

public class Supplement implements Comparable<Supplement>{

    private SUPPLEMENT_TYPE type;
    private int id;
    private String content;

    private Supplement() {
    }

    public Supplement(SUPPLEMENT_TYPE type) {
        this(type, -1, SourceDataConstants.BLANK);
    }

    public Supplement(SUPPLEMENT_TYPE type, int id, String content) {
        this.type = type;
        this.id = id;
        this.content = content;
    }

    public SUPPLEMENT_TYPE getType() {
        return type;
    }

    public int getId() {
        return id;
    }

    public Supplement setId(int id) {
        this.id = id;
        return this;
    }

    public String getContent() {
        return content;
    }

    public Supplement setContent(String content) {
        this.content = content;
        return this;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || getClass() != o.getClass()) return false;

        Supplement that = (Supplement) o;

        return new EqualsBuilder()
                .append(id, that.id)
                .append(type, that.type)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37)
                .append(type)
                .append(id)
                .toHashCode();
    }

    @Override
    public String toString() {
        return BibleConstants.SUPPLEMENT_NAMES_MAP.get(type) + " " + id + ": " + content;
    }

    @Override
    public int compareTo(Supplement other) {
        return Integer.compare(this.getId(), other.getId());
    }
}
