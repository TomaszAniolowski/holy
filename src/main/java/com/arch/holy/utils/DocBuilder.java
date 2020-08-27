package com.arch.holy.utils;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.util.Map;

public class DocBuilder {

    public DocBuilder() {
    }

    public Document getNewDocument() {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            return dBuilder.newDocument();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void fillElementWithAttributes(Document document, Element element, Map<String, String> attributeMap) {
        for (Map.Entry<String, String> attribute : attributeMap.entrySet()) {
            Attr attr = document.createAttribute(attribute.getKey());
            attr.setValue(attribute.getValue());
            element.setAttributeNode(attr);
        }
    }
}
