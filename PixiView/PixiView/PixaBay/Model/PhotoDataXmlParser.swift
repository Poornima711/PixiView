//
//  PhotoDataXmlParser.swift
//  PixiView
//
//  Created by Poornima Rao on 17/01/21.
//

import Foundation

class XmlParser: NSObject, XMLParserDelegate {
    
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Pixabay-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Pixabay-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Pixabay-Info.plist'.")
        }
        return value
    }
    
    private var myData: Data?
    private var currentElementName = ""
    private var inItem = false
    private var inTotalhits = false
    private var inTotal = false
    private var item: PhotoData?

    var ready = false

    var channel: PhotoResponse?
    var items: [PhotoData]?
    
    convenience init(data: Data) {
        self.init()
        myData = data
    }
    
    func parse() {
        let parser = XMLParser(data: myData ?? Data())
        parser.delegate = self
        parser.parse()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        ready = true
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        ready = false
    }
    
    // Terminate an element
    ///
    /// - Parameters:
    ///   - parser
    ///   - elementName: element name
    ///   - namespaceURI
    ///   - qName
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = elementName
        if elementName == "hits" {
            inItem = false
            items?.append(item ?? PhotoData())
            return
        }

        if elementName == "totalHits" {
            inTotalhits = false
        }
        
        if elementName == "total" {
            inTotal = false
        }
    }

    /// Starts an element
    ///
    /// - Parameters:
    ///   - parser
    ///   - elementName: element name
    ///   - namespaceURI
    ///   - qName
    ///   - attributeDict
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElementName = elementName
        if elementName == "hits" {
            inItem = true
            item = PhotoData()
        }
    }

    /// Collects other data
    ///
    /// - Parameters:
    ///   - parser
    ///   - string: Incoming partial data
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !inItem {
            // Not in item, store data to channel
            switch currentElementName {
            case "totalHits":
                print(string)
                channel?.totalHits += Int(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) ?? 0
            case "total":
                print(string)
                channel?.total += Int(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) ?? 0
            default:
                break
            }
            return
        }
        
        switch currentElementName {
        case "previewURL":
            print(string)
            item?.previewURL += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "webformatURL":
            print(string)
            item?.webformatURL += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "largeImageURL":
            print(string)
            item?.largeImageURL += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "userImageURL":
            print(string)
            item?.userImageURL += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "imageURL":
            print(string)
            item?.imageURL += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        default:
            break
        }
    }
}
