//
//  PageManager.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation


class PageManager {

    static let shared = PageManager()

    private(set) var page: Int
    public var totalResults = Int()

    private let resultsPerPage: Int
    private var maxPages: Int {
        return Int(ceil(Double(totalResults)/Double(resultsPerPage)))
    }

    // MARK: -   nextPage
    func nextPage(action: ()->()) {
        if page < maxPages {
            page += 1
            action()
        }
    }

    // MARK: -   resetPageCounting
    func resetPageCounting() {
        page = 1
    }

    private init() {
        page = 1
        resultsPerPage = 20
    }
}
