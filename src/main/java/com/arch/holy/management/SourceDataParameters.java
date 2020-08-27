package com.arch.holy.management;

public class SourceDataParameters {

    private boolean writeMainData;
    private boolean writePericopes;
    private boolean writeDefinitions;
    private boolean writeDictionary;
    private boolean writeSupplementIndexes;
    private boolean writeDataStructureIndexes;

    protected SourceDataParameters() {
        this(true, true, true, true, true, true);
    }

    protected SourceDataParameters(boolean writeMainData, boolean writePericopes, boolean writeDefinitions, boolean writeDictionary, boolean writeSupplementIndexes, boolean writeDataStructureIndexes) {
        this.writeMainData = writeMainData;
        this.writePericopes = writePericopes;
        this.writeDefinitions = writeDefinitions;
        this.writeDictionary = writeDictionary;
        this.writeSupplementIndexes = writeSupplementIndexes;
        this.writeDataStructureIndexes = writeDataStructureIndexes;
    }

    public boolean isWriteMainData() {
        return writeMainData;
    }

    public SourceDataParameters setWriteMainData(boolean writeMainData) {
        this.writeMainData = writeMainData;
        return this;
    }

    public boolean isWritePericopes() {
        return writePericopes;
    }

    public SourceDataParameters setWritePericopes(boolean writePericopes) {
        this.writePericopes = writePericopes;
        return this;
    }

    public boolean isWriteDefinitions() {
        return writeDefinitions;
    }

    public SourceDataParameters setWriteDefinitions(boolean writeDefinitions) {
        this.writeDefinitions = writeDefinitions;
        return this;
    }

    public boolean isWriteDictionary() {
        return writeDictionary;
    }

    public SourceDataParameters setWriteDictionary(boolean writeDictionary) {
        this.writeDictionary = writeDictionary;
        return this;
    }

    public boolean isWriteSupplementIndexes() {
        return writeSupplementIndexes;
    }

    public SourceDataParameters setWriteSupplementIndexes(boolean writeSupplementIndexes) {
        this.writeSupplementIndexes = writeSupplementIndexes;
        return this;
    }

    public boolean isWriteDataStructureIndexes() {
        return writeDataStructureIndexes;
    }

    public SourceDataParameters setWriteDataStructureIndexes(boolean writeDataStructureIndexes) {
        this.writeDataStructureIndexes = writeDataStructureIndexes;
        return this;
    }
}
