//
//  Article.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation

struct Article: Codable {

    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let publishedAtDate: Date?
    let stringUrl: String?
    let stringUrlToImage: String?

    var url: URL? {
        guard let string = stringUrl else { return nil }
        return URL(string: string)
    }
    var urlToImage: URL? {
        guard let string = stringUrlToImage else { return nil }
        return URL(string: string)
    }
    var publishedAt: String? {
        return DateManager.string(from: publishedAtDate, type: .full)
    }

    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case stringUrl = "url"
        case stringUrlToImage = "urlToImage"
        case publishedAtDate = "publishedAt"
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        source = try container.decodeIfPresent(Source.self, forKey: .source)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)

        stringUrl = try container.decodeIfPresent(String.self, forKey: .stringUrl)
        stringUrlToImage = try container.decodeIfPresent(String.self, forKey: .stringUrlToImage)

        let publishedAtRaw = try container.decodeIfPresent(String.self, forKey: .publishedAtDate)
        publishedAtDate = DateManager.date(from: publishedAtRaw)
    }
}
