//
//  PhotoDataEntity.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import Foundation

struct PhotoResponse: Decodable {
    var total: Int = 0
    var totalHits: Int = 0
    var hits: [PhotoData] = []
    
    enum PhotoResponseKeys: String, CodingKey {
        case total
        case totalHits
        case hits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoResponseKeys.self)
        total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        totalHits = try container.decodeIfPresent(Int.self, forKey: .totalHits) ?? 0
        hits = try container.decodeIfPresent([PhotoData].self, forKey: .hits) ?? [PhotoData]()
    }
}

struct PhotoData: Decodable {
    //var photoId: Int = 0
    var previewURL: String = ""
    var imageURL: String = ""
    var largeImageURL: String = ""
    var userImageURL: String = ""
    var webformatURL: String = ""
    
    enum PhotoDataKeys: String, CodingKey {
        //case id
        case previewURL
        case imageURL
        case largeImageURL
        case userImageURL
        case webformatURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoDataKeys.self)
        //photoId = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL) ?? ""
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        largeImageURL = try container.decodeIfPresent(String.self, forKey: .largeImageURL) ?? ""
        userImageURL = try container.decodeIfPresent(String.self, forKey: .userImageURL) ?? ""
        webformatURL = try container.decodeIfPresent(String.self, forKey: .webformatURL) ?? ""
    }
}
