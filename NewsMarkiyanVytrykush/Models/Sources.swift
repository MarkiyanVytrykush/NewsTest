//
//  Sources.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation


struct Sources: Codable {
    let name: String
    let description: String
    let stringUrl: String
    let category: String
    let language: String
    let country: String

    var url: URL? {
        return URL(string: stringUrl)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case stringUrl = "url"
        case category
        case language
        case country
    }

}
