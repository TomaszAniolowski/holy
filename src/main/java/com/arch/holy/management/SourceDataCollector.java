package com.arch.holy.management;

import com.arch.holy.model.bible.BibleConstants;
import com.arch.holy.model.bible.MetadataCollector;
import com.arch.holy.model.enums.TESTAMENT_ID;
import com.arch.holy.model.enums.TOME_ID;
import com.arch.holy.model.response.Content;
import com.arch.holy.model.response.ContentContainer;
import com.arch.holy.model.response.ContentContainerList;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class SourceDataCollector {

    private final RequestSender sender;
    private final JsonUtils jsonUtils;
    private final Map<String,String> SECURED_URL_REQ_PARAMS_MAP;

    protected SourceDataCollector(String session) {
        sender = RequestSenderFactory.getNewRequestSender();
        jsonUtils = JsonUtilsFactory.getNewJsonUtils();
        SECURED_URL_REQ_PARAMS_MAP = new HashMap<>(){{
            put("Cookie", String.format(SourceDataConstants.COOKIE_TMPLT, session));
        }};
    }

    /**
     * This method returns list of tomes, which contains list of chapter contents.
     * It sends queue of GET request to REST API https://pismoswiete.pl/api/tome/<<TOME>>/chapter/<<CHAPTER>> and loads data.
     *
     * @param chapters map with tome siglum as a string key and tome's last chapter id as a integer value
     * @return tomeResponses    list of tomes, which contains list of chapter contents
     */
    protected List<ContentContainerList> getTomesContent(Map<String, String> chapters) {
        List<ContentContainerList> tomeResponses = new ArrayList<>();
        for (Map.Entry<String, String> mapEntry : chapters.entrySet()) {
            String tomeSiglum = mapEntry.getKey();
            int lastChapterSiglum = Integer.parseInt(mapEntry.getValue());
            List<ContentContainer> chapterResponses = this.getSpecificTomeContent(tomeSiglum, lastChapterSiglum);
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
     */
    protected void saveChapterHTML(MetadataCollector metadataCollector, List<ContentContainerList> contentContainerList) {
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
                String outputPath = String.format(SourceDataConstants.BIBLE_CONTENT_FILE_PATH, new Date());
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

    private List<ContentContainer> getSpecificTomeContent(String tome, int lastChapter) {
        List<ContentContainer> tomeContent = new ArrayList<>();

        if (tome.equals(SourceDataConstants.EXCEPTIONAL_TOME_SIGLUM)) {
            ContentContainer chapterContent = this.getSpecificChapterContent(tome, SourceDataConstants.EXCEPTIONAL_TOME_FIRST_CHAPTER);
            tomeContent.add(chapterContent);
        }

        for (int chapterId = 1; chapterId <= lastChapter; chapterId++) {
            ContentContainer chapterContent = this.getSpecificChapterContent(tome, String.valueOf(chapterId));
            tomeContent.add(chapterContent);
        }

        return tomeContent;
    }

    private ContentContainer getSpecificChapterContent(String tome, String chapter) {
        String urlLiteral = String.format(SourceDataConstants.CHAPTERS_CONTENT_REST_API_URL_TMPLT, URLEncoder.encode(tome, StandardCharsets.UTF_8), chapter);
        String response = sender.GET(urlLiteral, SECURED_URL_REQ_PARAMS_MAP);
        ContentContainer chapterData = jsonUtils.convertToContentContainer(response);
        String rawContent = chapterData.getChapterContentDecoded();
        String wrappedContent = String.format(SourceDataConstants.WRAPPED_CHAPTER_CONTENT_TMPLT, rawContent);
        chapterData.setChapterContent(wrappedContent);
        return chapterData;
    }

}
