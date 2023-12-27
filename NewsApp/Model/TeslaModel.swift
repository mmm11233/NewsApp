//
//  TeslaModel.swift
//  NewsApp
//
//  Created by Mariam Joglidze on 27.12.23.
//

import Foundation
struct NewsResponse: Codable {
    let  articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String
    let urlToImage: String?
}
