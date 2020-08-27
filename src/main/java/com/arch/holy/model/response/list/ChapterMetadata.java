package com.arch.holy.model.response.list;

public class ChapterMetadata implements Comparable<ChapterMetadata> {

    private int id;

    private String siglum;

    public ChapterMetadata() {
    }

    public ChapterMetadata(int id, String siglum) {
        this.id = id;
        this.siglum = siglum;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSiglum() {
        return siglum;
    }

    public void setSiglum(String siglum) {
        this.siglum = siglum;
    }

    @Override
    public int compareTo(ChapterMetadata o) {
        int thisSiglum = 0;
        int oSiglum = 0;
        try {
            thisSiglum = Integer.parseInt(this.getSiglum());
            oSiglum = Integer.parseInt(o.getSiglum());
        } catch (NumberFormatException e) {
            if (this.getSiglum().toUpperCase().equals("PROLOG")) {
                return -1;
            } else if (o.getSiglum().toUpperCase().equals("PROLOG")) {
                return 1;
            }
        }

        return Integer.compare(thisSiglum, oSiglum);
    }
}
