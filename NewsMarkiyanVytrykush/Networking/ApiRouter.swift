//
//  ApiRouter.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation


// MARK: -  enum  NewsApiRouter
enum NewsApiRouter {

    case topHeadlines(category: String?, country: String?, source: String?, page: Int)
    case everything(searchWord: String, page: Int)
    case sources(category: String?, country: String?, language: String?)
}

// MARK: -  extension NewsApiRouter
extension NewsApiRouter {

    private static let apiKey = URLQueryItem(name: "apiKey", value: "30b2f4b3a082409fb93c13a252523d4c")
    private static let baseURL = "https://newsapi.org"

    private var path: String {
        switch self {
        case .topHeadlines:
            return "/v2/top-headlines"
        case .everything:
            return "/v2/everything"
        case .sources:
            return "/v2/sources"
        }
    }

    var queryParameters: [String: String] {
        switch self {
        case .topHeadlines(let category, let country, let source, let page):
            var parameters : [String: String] = [:]
            parameters[Parameters.category.rawValue] = category
            parameters[Parameters.country.rawValue] = country
            parameters[Parameters.sources.rawValue] = source
            parameters[Parameters.page.rawValue] = String(page)
            return parameters
        case .everything(let searchWord, let page):
            var parameters : [String: String] = [:]
            parameters[Parameters.searchingText.rawValue] = searchWord
            parameters[Parameters.page.rawValue] = String(page)
            return parameters
        case .sources(let category, let country, let language):
            var parameters : [String: String] = [:]
            parameters[Parameters.category.rawValue] = category
            parameters[Parameters.country.rawValue] = country
            parameters[Parameters.language.rawValue] = language
            return parameters
        }
    }

    private enum HttpMethods: String {
        case get = "GET"
    }

    private var method: HttpMethods {
        switch self {
        case .topHeadlines:
            return .get
        case .everything:
            return .get
        case .sources:
            return .get
        }
    }

    private var requestUrl: URL? {
        guard var comp = URLComponents(string: NewsApiRouter.baseURL) else { return nil }
        comp.path = path
        comp.queryItems = (queryParameters.map{ URLQueryItem(name: $0.key, value: $0.value) }) + [NewsApiRouter.apiKey]
        return comp.url
    }

    func asRequest() throws -> URLRequest {
        guard let url = requestUrl else { throw ApiError.notRightURL }
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = method.rawValue
        return urlReq
    }
}

// MARK: -  extension NewsApiRouter
extension NewsApiRouter: Codable {

    private enum CodingKeys: String, CodingKey {
        case newsType, topHeadlinesCaseParameters, everythingCaseParameters, sourcesCaseParameters
    }

    private enum NewsType: String, Codable {
        case topHeadlinesCase, everythingCase, sourcesCase
    }

    private struct TopHeadlinesCaseParameters: Codable {
        let category: String?, country: String?, source: String?, page: Int
    }

    private struct EverythingCaseParameters: Codable {
        let searchWord: String, page: Int
    }

    private struct SourcesCaseParameters: Codable {
        let category: String?, country: String?, language: String?
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let newsType = try container.decode(NewsType.self, forKey: .newsType)

        switch newsType {
        case .topHeadlinesCase:
            let topHeadlinesCaseParameters = try container.decode(TopHeadlinesCaseParameters.self, forKey: .topHeadlinesCaseParameters)
            self = .topHeadlines(category: topHeadlinesCaseParameters.category, country: topHeadlinesCaseParameters.country, source: topHeadlinesCaseParameters.source, page: topHeadlinesCaseParameters.page)
        case .everythingCase:
            let everythingCaseParameters = try container.decode(EverythingCaseParameters.self, forKey: .everythingCaseParameters)
            self = .everything(searchWord: everythingCaseParameters.searchWord, page: everythingCaseParameters.page)
        case .sourcesCase:
            let sourcesCaseParameters = try container.decode(SourcesCaseParameters.self, forKey: .sourcesCaseParameters)
            self = .sources(category: sourcesCaseParameters.category, country: sourcesCaseParameters.country, language: sourcesCaseParameters.language)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .topHeadlines(let category, let country, let source, _):
            try container.encode(NewsType.topHeadlinesCase, forKey: .newsType)
            try container.encode(TopHeadlinesCaseParameters(category: category, country: country, source: source, page: 1), forKey: .topHeadlinesCaseParameters)
        case .everything(let searchWord, _):
            try container.encode(NewsType.everythingCase, forKey: .newsType)
            try container.encode(EverythingCaseParameters(searchWord: searchWord, page: 1), forKey: .everythingCaseParameters)
        case .sources(let category, let country, let language):
            try container.encode(NewsType.sourcesCase, forKey: .newsType)
            try container.encode(SourcesCaseParameters(category: category, country: country, language: language), forKey: .sourcesCaseParameters)
        }
    }
}
