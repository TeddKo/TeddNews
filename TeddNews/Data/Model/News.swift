//
//  News.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import Foundation

struct News: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
    
    struct Article: Codable {
        let author: String?
        let title: String?
        let description: String?
        let urlToImage: String?
        let publishedAt: String?
    }
}
