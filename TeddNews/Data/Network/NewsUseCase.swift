//
//  NewsUseCase.swift
//  TeddNews
//
//  Created by Ko Minhyuk on 6/6/25.
//

import Foundation

class NewsUseCase {
    
    static let shared = NewsUseCase()
    
    func fetchAll(callback: (News) -> ()) async {
        guard var url = URL(string: "https://newsapi.org/v2/top-headlines?country=us") else { return }
        
        url.append(queryItems: [URLQueryItem(name: "apiKey", value: "228bfef5b0344af9bc2248df3271860f")])
        
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await session.data(for: urlRequest)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let news = try decoder.decode(News.self, from: data)
            
            callback(news)
            
        } catch {
            print(error)
        }
    }
    
    func fetchQuery(
        _ query: String,
        callback: (News) -> Void
    ) async {
        guard var url = URL(string: "https://newsapi.org/v2/everything?q=\(query)") else { return }
        
        url.append(queryItems: [URLQueryItem(name: "apiKey", value: "228bfef5b0344af9bc2248df3271860f")])
        
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await session.data(for: urlRequest)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let news = try decoder.decode(News.self, from: data)
            
            callback(news)
        } catch {
            print(error)
        }
    }
}
