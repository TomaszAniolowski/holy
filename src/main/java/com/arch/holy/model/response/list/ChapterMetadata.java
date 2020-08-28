package com.arch.holy.model.response.list;

public class ChapterMetadata implements Comparable<ChapterMetadata> {

    private int id;

    private String sigl;

    public ChapterMetadata() {
    }

    public ChapterMetadata(int id, String sigl) {
        this.id = id;
        this.sigl = sigl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSigl() {
        return sigl;
    }

    public void setSigl(String sigl) {
        this.sigl = sigl;
    }

    @Override
    public int compareTo(ChapterMetadata o) {
        int thisSiglum = 0;
        int oSiglum = 0;
        try {
            thisSiglum = Integer.parseInt(this.getSigl());
            oSiglum = Integer.parseInt(o.getSigl());
        } catch (NumberFormatException e) {
            if (this.getSigl().toUpperCase().equals("PROLOG")) {
                return -1;
            } else if (o.getSigl().toUpperCase().equals("PROLOG")) {
                return 1;
            }
        }

        return Integer.compare(thisSiglum, oSiglum);
    }
}
