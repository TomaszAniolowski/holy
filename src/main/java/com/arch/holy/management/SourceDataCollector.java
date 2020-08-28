package com.arch.holy.management;

import com.arch.holy.model.bible.BibleConstants;
import com.arch.holy.model.bible.MetadataCollector;
import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import com.arch.holy.model.response.content.Content;
import com.arch.holy.model.response.content.ContentContainer;
import com.arch.holy.model.response.content.ContentContainerList;
import com.arch.holy.model.response.list.ChapterList;
import com.arch.holy.model.response.list.ChapterMetadata;
import com.arch.holy.model.response.list.TomeMetadata;
import com.arch.holy.utils.JsonUtils;
import com.arch.holy.utils.JsonUtilsFactory;
import com.arch.holy.utils.RequestSender;
import com.arch.holy.utils.RequestSenderFactory;
import com.google.common.base.Charsets;
import com.google.common.io.CharSink;
import com.google.common.io.FileWriteMode;
import com.google.common.io.Files;

import java.io.File;
import java.io.IOException;
import java.util.*;

public class SourceDataCollector {

    private RequestSender sender;
    private JsonUtils jsonUtils;

    protected SourceDataCollector() {
        sender = RequestSenderFactory.getNewRequestSender();
        jsonUtils = JsonUtilsFactory.getNewJsonUtils();
    }

    /**
     * This method returns map with tome siglum as a key and tome's last chapter id as a value.
     * It sends GET request to REST API https://pismoswiete.pl/api/tome and extracts useful data.
     *
     * @return tomeLastChapterMap   map with tome siglum as a string key and tome's last chapter id as a integer value
     */
    protected Map<String, Integer> getTomeAndLastChapterMap() {
        Map<String, Integer> tomeLastChapterMap = new HashMap<>();
        String response = sender.GET(SourceDataConstants.CHAPTER_LIST_REST_API_URL);
        ChapterList chapterList = (ChapterList) jsonUtils.convertToBibleResponseInstance(response, ChapterList.class);
        List<TomeMetadata> tomeMetadataList = chapterList.getData();

        for (TomeMetadata tomeMetadata : tomeMetadataList) {
            List<ChapterMetadata> chapters = tomeMetadata.getChapters();
            Collections.sort(chapters);
            String tomeSiglum = tomeMetadata.getSigl();
            int lastChapter = Integer.parseInt(chapters.get(chapters.size() - 1).getSigl());
            tomeLastChapterMap.put(tomeSiglum, lastChapter);
        }

        return tomeLastChapterMap;
    }

    /**
     * This method returns list of tomes, which contains list of chapter contents.
     * It sends queue of GET request to REST API https://pismoswiete.pl/api/tome/<<TOME>>/chapter/<<CHAPTER>> and loads data.
     *
     * @param session  id of session with user logged in
     * @param chapters map with tome siglum as a string key and tome's last chapter id as a integer value
     * @return tomeResponses    list of tomes, which contains list of chapter contents
     */
    protected List<ContentContainerList> getTomesContent(String session, Map<String, String> chapters) {
        String cookie = String.format(SourceDataConstants.COOKIE_TMPLT, session);
        List<ContentContainerList> tomeResponses = new ArrayList<>();
        for (Map.Entry<String, String> mapEntry : chapters.entrySet()) {
            String tomeSiglum = mapEntry.getKey();
            int lastChapterSiglum = Integer.parseInt(mapEntry.getValue());
            List<ContentContainer> chapterResponses = this.getSpecificTomeContent(tomeSiglum, lastChapterSiglum, cookie);
            ContentContainerList tomeContent = new ContentContainerList(chapterResponses);
            tomeResponses.add(tomeContent);
        }
        return tomeResponses;
    }

    /**
     * This method saves list of tomes which contains list of chapter contents to file.
     * If parameter ifCleanUp equals true, then it removes old one file.
     * Each line contains data in format: TESTAMENT_ID/TOME_NUM/CHAPTER_NUM::-::<DIV>DATA</DIV>
     *
     * @param metadataCollector    MetadataCollector object to find testament id for tome
     * @param contentContainerList list of tomes, which contains list of chapter contents
     * @param ifCleanUp            boolean value indicating if old file should be removed
     */
    protected void saveChapterHTML(MetadataCollector metadataCollector, List<ContentContainerList> contentContainerList, String outputPath, boolean ifCleanUp) {
        if (ifCleanUp) {
            File file = new File(outputPath);
            String message = (file.delete()) ? " removed" : " not removed";
            System.out.println(outputPath + message);
        }

        this.saveChapterHTML(metadataCollector, contentContainerList, outputPath);
    }

    private List<ContentContainer> getSpecificTomeContent(String tome, int lastChapter, String cookie) {
        List<ContentContainer> tomeContent = new ArrayList<>();

        if (tome.equals(SourceDataConstants.EXCEPTIONAL_TOME_SIGLUM)) {
            ContentContainer chapterContent = this.getSpecificChapterContent(tome, SourceDataConstants.EXCEPTIONAL_TOME_FIRST_CHAPTER, cookie);
            tomeContent.add(chapterContent);
        }

        for (int chapterId = 1; chapterId <= lastChapter; chapterId++) {
            ContentContainer chapterContent = this.getSpecificChapterContent(tome, String.valueOf(chapterId), cookie);
            tomeContent.add(chapterContent);
        }

        return tomeContent;
    }

    private ContentContainer getSpecificChapterContent(String tome, String chapter, String cookie) {
        String urlLiteral = String.format(SourceDataConstants.CHAPTERS_CONTENT_REST_API_URL_TMPLT, tome, chapter);
        String response = sender.GET(urlLiteral, cookie);
        ContentContainer chapterData = (ContentContainer) jsonUtils.convertToBibleResponseInstance(response, ContentContainer.class);
        String rawContent = chapterData.getChapterContentDecoded();
        String wrappedContent = String.format(SourceDataConstants.WRAPPED_CHAPTER_CONTENT_TMPLT, rawContent);
        chapterData.setChapterContent(wrappedContent);
        return chapterData;
    }

    private void saveChapterHTML(MetadataCollector metadataCollector, List<ContentContainerList> contentContainerList, String outputPath) {
        for (ContentContainerList responseList : contentContainerList) {
            List<ContentContainer> tomeList = responseList.getTomeList();
            for (ContentContainer contentContainer : tomeList) {
                Content data = contentContainer.getData();
                String tomeSiglum = data.getTome().getSigl();
                TESTAMENT_ID testamentId = metadataCollector.findTestamentIdForTome((TOME_ID) BibleConstants.TOME_SIGLA_MAP.getKey(tomeSiglum));
                String chapterSiglum = data.getChapter().getSigl();
                String sigla = String.format("%s/%s/%s", testamentId.name(), tomeSiglum, chapterSiglum);
                String content = data.getChapter().getContent();
                String lineToSave = sigla + SourceDataConstants.DATA_SEPARATOR + content;
                File file = new File(outputPath);
                CharSink chs = Files.asCharSink(file, Charsets.UTF_8, FileWriteMode.APPEND);
                try {
                    chs.write(lineToSave + SourceDataConstants.NEW_LINE);
                    System.out.println(sigla + " saved");
                } catch (IOException e) {
                    e.printStackTrace();
                    System.out.println(sigla + " not saved");
                }

            }
        }
    }

}
