//
//  NewsResult.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation

enum ApiType: String, CaseIterable {
    case articles
    case sources
}

struct ResultsContainer<T: Codable> : Codable {
    let totalResults: Int?
    var results: [T]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        let infoTypeKey = container.allKeys.filter { key in ApiType.allCases.contains(where: { $0.rawValue == key.stringValue }) }
        if !infoTypeKey.isEmpty {
            results = try container.decode([T].self, forKey: infoTypeKey[0])
        } else {
            results = []
        }
        let totalResultskey = container.allKeys.filter { $0.stringValue == "totalResults" }
        if !totalResultskey.isEmpty {
            totalResults = try container.decode(Int.self, forKey: totalResultskey[0])
        } else {
            totalResults = nil
        }
    }
}



