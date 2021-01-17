//
//  PhotoDataXmlParser.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation

class XmlParser: NSObject, XMLParserDelegate {
    
    func parseData() {
        if let path = Bundle.main.url(forResource: "Books", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {

//        if elementName == "book" {
//            bookTitle = String()
//            bookAuthor = String()
//        }

  //      self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if elementName == "book" {
//            let book = Book(bookTitle: bookTitle, bookAuthor: bookAuthor)
//            books.append(book)
//        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

//        if (!data.isEmpty) {
//            if self.elementName == "title" {
//                bookTitle += data
//            } else if self.elementName == "author" {
//                bookAuthor += data
//            }
//        }
    }
    
}
