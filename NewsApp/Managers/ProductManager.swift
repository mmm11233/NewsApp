//
//  ProductManager.swift
//  NewsApp
//
//  Created by Mariam Joglidze on 27.12.23.
//

import Foundation
import NetSwift

final class ProductManager {
    static let shared = ProductManager()
    var articles: [Article] = []
    
     init() {}
    
    func fetchProducts(completion: @escaping ([Article]) -> Void) {
        
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=707df27fa5a4451ab0408eebc146ce68"
        guard let URL = URL(string: urlString) else { return }
        
        NetworkManager.shared.fetchDecodableData(from: URL, responseType: NewsResponse.self, completion: { result in
            switch result {
            case .success(let data):
                self.articles = data.articles
                completion(self.articles)
            case .failure(_):
                completion([])
            }
        })
    }
}
