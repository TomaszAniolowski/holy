package com.arch.holy.management;

import java.util.Comparator;
import java.util.Map;
import java.util.TreeMap;

public class SourceDataConstants {

    // TEXT CONSTANTS
    public static final String BLANK = "";
    public static final String SPACE = " ";
    public static final String COLON = ":";
    public static final String NEW_LINE = "\n";
    public static final String COMMA = ",";
    public static final String COMMA_WITH_SPACE = COMMA + SPACE;
    public static final String SIGLA_SEPARATOR = "/";
    public static final String DATA_SEPARATOR = "::-::";
    public static final String DICTIONARY_DEFINIENS_SEPARATOR = "%-%";
    public static final String BIBLE_CONTENT_FILE_PATH = "src/main/resources/source-data/bible-content_%tY%1$tm%1$td%1$tH%1$tM%1$tS";

    // SOURCE DATA COLLECTOR CONSTANTS
    public static final String CHAPTER_LIST_REST_API_URL = "https://pismoswiete.pl/api/tome";
    public static final String CHAPTERS_CONTENT_REST_API_URL_TMPLT = "https://pismoswiete.pl/api/tome/%s/chapter/%s";
    public static final String COOKIE_TMPLT = "_ga=GA1.2.94427899.1577717663; _gidGA1.2.171240071.1581009365; _gat=1; PHPSESSID=%s";
    public static final String WRAPPED_CHAPTER_CONTENT_TMPLT = "<DIV>%s</DIV>";
    public static final String EXCEPTIONAL_TOME_SIGLUM = "Syr";
    public static final String EXCEPTIONAL_TOME_FIRST_CHAPTER = "Prolog";
    public static final Map<String, String> DECODER_MAP = new TreeMap<>(
            Comparator.comparingInt(s -> ((String) s).length())
    ) {{
        put("\\u0105", "ą");
        put("\\u0107", "ć");
        put("\\u0119", "ę");
        put("\\u0142", "ł");
        put("\\u0144", "ń");
        put("\\u00f3", "ó");
        put("\\u015b", "ś");
        put("\\u017a", "ź");
        put("\\u017c", "ż");
        put("\\u0104", "Ą");
        put("\\u0106", "Ć");
        put("\\u0118", "Ę");
        put("\\u0141", "Ł");
        put("\\u0143", "Ń");
        put("\\u00d3", "Ó");
        put("\\u015a", "Ś");
        put("\\u0179", "Ź");
        put("\\u017b", "Ż");
        put("\\u0161", "š");
        put("\\ufb01", "fi");
        put("\\u003C", "<");
        put("\\u00ab", "«");
        put("\\u003E", ">");
        put("\\u00bb", "»");
        put("\\u0022", "\"");
        put("\\/", "/");
        put("\\u2013", "–");
        put("\\u2011", "‑");
        put("\\u201e", "„");
        put("\\u201d", "”");
        put("\\u2018", "‘");
        put("\\u2019", "’");
        put("\\u0027", "'");
        put("\\u2026", "…");
        put("\\u00a7", "§");
        put("\\u00a0", SPACE); // hard space
        put("&nbsp;", SPACE); // hard space
        put("\\u0026nbsp;", SPACE); // simple space for a new line
        put("\\u2008", SPACE); // simple space for a new line
        put("\\r", SPACE); // simple space for a new line
        put("\\u2020", SPACE); // simple space for a new line
    }};

    // SOURCE DATA EXTRACTOR AND INTERPRETATOR CONSTANTS
    public static final String DATA_ROOT_TAG_END = "</DIV>";
    public static final String VRS_LOC_START = "sigl-start";
    public static final String VRS_LOC_END = "sigl-end";
    public static final String VERSE_CLASS = "werset";
    public static final String PERICOPE_CLASS = "perykopa";
    public static final String CHAPTER_CLASS = "rozdzial";
    public static final String DIV_TAG = "div";
    public static final String SPAN_TAG = "span";
    public static final String SUP_TAG = "sup";
    public static final String A_TAG = "a";
    //    public static final String SUPP_ID_ATTR = "id";
    public static final String SUPP_DATA_TARGET_ID_ATTR = "data-target-id";
    public static final String DEFINITION_ENTRY_CLASSNAME = "definition-box";
    public static final String DICTIONARY_ENTRY_CLASSNAME = "dictionary-box";
    public static final String DEFINITION_ID_PREFIX = "definition_";
    public static final String DICTIONARY_ID_PREFIX = "dictionary_";

    // SOURCE DATA WRITER CONSTANTS
    public static final String OUTPUT_ROOT_PATH = "output\\bbl\\";
    public static final String OUTPUT_DATA_ROOT_PATH = OUTPUT_ROOT_PATH + "data\\";
    public static final String OUTPUT_METADATA_ROOT_PATH = OUTPUT_ROOT_PATH + "metadata\\";
    public static final String OUTPUT_SUPP_E_ROOT_PATH = OUTPUT_METADATA_ROOT_PATH + "sppntt\\";
    public static final String OUTPUT_E_SUPP_ROOT_PATH = OUTPUT_METADATA_ROOT_PATH + "nttspp\\";
    public static final String TOME_OUTPUT_PATH_TMPL = OUTPUT_DATA_ROOT_PATH + "tomes\\%d-%s\\%d-%d.xml";
    public static final String PERICOPE_OUTPUT_PATH_TMPL = OUTPUT_DATA_ROOT_PATH + "pericopes\\per_%d_%s.xml";
    public static final String DICTIONARY_OUTPUT_PATH = OUTPUT_DATA_ROOT_PATH + "supplements\\DICTIONARY.xml";
    public static final String DEFINITIONS_OUTPUT_PATH_TMPL = OUTPUT_DATA_ROOT_PATH + "supplements\\def-%d-%d.xml";
    public static final String V_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_METADATA_ROOT_PATH + "vrss\\v-%d-%d.xml";
    public static final String P_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_METADATA_ROOT_PATH + "prcps\\p-%d-%d.xml";
    public static final String CH_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_METADATA_ROOT_PATH + "chptrs\\ch-%d-%d.xml";
    public static final String TM_INDEXES_OUTPUT_PATH = OUTPUT_METADATA_ROOT_PATH + "tms\\tm-rdz-ap.xml";
    public static final String TST_INDEXES_OUTPUT_PATH = OUTPUT_METADATA_ROOT_PATH + "tstmnts\\tst-s-n.xml";
    public static final String SV_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_SUPP_E_ROOT_PATH + "v\\%s-v-%d-%d.xml";
    public static final String SP_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_SUPP_E_ROOT_PATH + "p\\%s-p-%d-%d.xml";
    public static final String SCH_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_SUPP_E_ROOT_PATH + "ch\\%s-ch-%d-%d.xml";
    public static final String ST_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_SUPP_E_ROOT_PATH + "t\\%s-t-%d-%d.xml";
    public static final String VS_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_E_SUPP_ROOT_PATH + "v\\v-%s-%d-%d.xml";
    public static final String PS_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_E_SUPP_ROOT_PATH + "p\\p-%s-%d-%d.xml";
    public static final String CHS_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_E_SUPP_ROOT_PATH + "ch\\ch-%s-%d-%d.xml";
    public static final String TS_INDEXES_OUTPUT_PATH_TMPL = OUTPUT_E_SUPP_ROOT_PATH + "t\\t-%s-%d-%d.xml";

    public static final String DATA_CH_NAMESPACE_PREFIX = "bbl";
    public static final String DATA_PER_NAMESPACE_PREFIX = "bp";
    public static final String DATA_SUPP_NAMESPACE_PREFIX = "br";
    public static final String METADATA_NAMESPACE_PREFIX = "bi";
    public static final String DATA_CH_NAMESPACE_URI = "http://www.arch.com/holy/data/chapter";
    public static final String DATA_PER_NAMESPACE_URI = "http://www.arch.com/holy/data/pericope";
    public static final String DATA_SUPP_NAMESPACE_URI = "http://www.arch.com/holy/data/supplement";
    public static final String METADATA_NAMESPACE_URI = "http://www.arch.com/holy/metadata/indexes";

    public static final String CHAPTER_ELM = "chapter";
    public static final String PERICOPE_ROOT_ELM = "pericopes";
    public static final String PERICOPE_ELM = "pericope";
    public static final String VERSE_ELM = "verse";
    public static final String SUPPLEMENT_ROOT_ELM = "supplements";
    public static final String SUPPLEMENT_ENTRY_ELM = "entry";
    public static final String CHAPTER_ELM_WITH_PREFIX = DATA_CH_NAMESPACE_PREFIX + COLON + CHAPTER_ELM;
    public static final String PERICOPE_ROOT_ELM_WITH_PREFIX = DATA_PER_NAMESPACE_PREFIX + COLON + PERICOPE_ROOT_ELM;
    public static final String PERICOPE_ELM_WITH_PREFIX = DATA_PER_NAMESPACE_PREFIX + COLON + PERICOPE_ELM;
    public static final String VERSE_ELM_WITH_PREFIX = DATA_CH_NAMESPACE_PREFIX + COLON + VERSE_ELM;
    public static final String SUPPLEMENT_ROOT_ELM_WITH_PREFIX = DATA_SUPP_NAMESPACE_PREFIX + COLON + SUPPLEMENT_ROOT_ELM;
    public static final String SUPPLEMENT_ENTRY_ELM_WITH_PREFIX = DATA_SUPP_NAMESPACE_PREFIX + COLON + SUPPLEMENT_ENTRY_ELM;

    public static final String ID_ATTR = "id";
    public static final String SIGLUM_ATTR = "siglum";
    public static final String ABS_NUM_ATTR = "absNum";
    public static final String REL_NUM_ATTR = "relNum";
    public static final String PREV_ATTR = "prev";
    public static final String NEXT_ATTR = "next";
    public static final String TOME_ID_ATTR = "tomeID";
    public static final String QUANTITY_ATTR = "quantity";
    public static final String SIZE_ATTR = "size";
    public static final String FIRST_VERSE_ATTR = "firstVerseAbsNum";
    public static final String LAST_VERSE_ATTR = "lastVerseAbsNum";
    public static final String RANGE_START_ATTR = "rangeStart";
    public static final String RANGE_END_ATTR = "rangeEnd";
    public static final String SUPP_TYPE_ATTR = "suppType";
    public static final String ENT_TYPE_ATTR = "entType";
    public static final String SUPP_ID_ATTR = "suppId";
    public static final String ENT_ABS_NUM_ATTR = "entAbsNum";
    public static final String DEFINIENDUM_ATTR = "definiendum";
    public static final String TESTAMENT_ID_ATTR = "testamentID";
    public static final String PERICOPE_ABS_NUM_ATTR = "pericopeAbsNum";
    public static final String CHAPTER_ABS_NUM_ATTR = "chapterAbsNum";
    public static final String TOME_ABS_NUM_ATTR = "tomeAbsNum";
    public static final String TST_FIRST_VERSE_ABS_NUM_ATTR = "firstVerseAbsNum";
    public static final String TST_LAST_VERSE_ABS_NUM_ATTR = "lastVerseAbsNum";

    public static final String METADATA_V_ROOT_ELM = "verses";
    public static final String METADATA_V_FST_CHILD_ELM = "verse";
    public static final String METADATA_P_ROOT_ELM = "pericopes";
    public static final String METADATA_P_FST_CHILD_ELM = "pericope";
    public static final String METADATA_CH_ROOT_ELM = "chapters";
    public static final String METADATA_CH_FST_CHILD_ELM = "chapter";
    public static final String METADATA_TM_ROOT_ELM = "tomes";
    public static final String METADATA_TM_FST_CHILD_ELM = "tome";
    public static final String METADATA_TST_ROOT_ELM = "testaments";
    public static final String METADATA_TST_FST_CHILD_ELM = "testament";
    public static final String METADATA_SE_ROOT_ELM = "supps-en-entries";
    public static final String METADATA_SE_FST_CHILD_ELM = "supps-en-entry";
    public static final String METADATA_ES_ROOT_ELM = "en-supps-entries";
    public static final String METADATA_ES_FST_CHILD_ELM = "en-supps-entry";
    public static final String METADATA_SUPP_ENTRY_ELM = "supp-entry";
    public static final String METADATA_CH_FIRST_VERSE_ELM = "first-verse";
    public static final String METADATA_CH_LAST_VERSE_ELM = "last-verse";
    public static final String METADATA_TM_FIRST_CHAPTER_ELM = "first-chapter";
    public static final String METADATA_TM_LAST_CHAPTER_ELM = "last-chapter";
    public static final String METADATA_V_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_V_ROOT_ELM;
    public static final String METADATA_V_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_V_FST_CHILD_ELM;
    public static final String METADATA_P_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_P_ROOT_ELM;
    public static final String METADATA_P_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_P_FST_CHILD_ELM;
    public static final String METADATA_CH_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_CH_ROOT_ELM;
    public static final String METADATA_CH_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_CH_FST_CHILD_ELM;
    public static final String METADATA_TM_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_TM_ROOT_ELM;
    public static final String METADATA_TM_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_TM_FST_CHILD_ELM;
    public static final String METADATA_TST_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_TST_ROOT_ELM;
    public static final String METADATA_TST_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_TST_FST_CHILD_ELM;
    public static final String METADATA_SE_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_SE_ROOT_ELM;
    public static final String METADATA_SE_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_SE_FST_CHILD_ELM;
    public static final String METADATA_ES_ROOT_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_ES_ROOT_ELM;
    public static final String METADATA_ES_FST_CHILD_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_ES_FST_CHILD_ELM;
    public static final String METADATA_SUPP_ENTRY_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_SUPP_ENTRY_ELM;
    public static final String METADATA_CH_FIRST_VERSE_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_CH_FIRST_VERSE_ELM;
    public static final String METADATA_CH_LAST_VERSE_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_CH_LAST_VERSE_ELM;
    public static final String METADATA_TM_FIRST_CHAPTER_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_TM_FIRST_CHAPTER_ELM;
    public static final String METADATA_TM_LAST_CHAPTER_ELM_WITH_PREFIX = METADATA_NAMESPACE_PREFIX + COLON + METADATA_TM_LAST_CHAPTER_ELM;

    public static final int DEFINITIONS_RANGE_LIMIT = 100;
    public static final int GENERAL_INDEX_ENTRY_LIMIT = 500;
    public static final int DICTIONARY_INDEX_ENTRY_LIMIT = 150;
    public static final int TOME_SUPPLEMENT_INDEX_ENTRY_LIMIT = 20;
}
