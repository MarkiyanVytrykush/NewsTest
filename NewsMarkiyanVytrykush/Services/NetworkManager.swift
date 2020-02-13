//
//  NewsManager.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation

enum NewsTypeAboutInfo: Int {
    case headlines = 0
    case publishers = 1
}

// MARK: -   NetworkManager
class NetworkManager {

    static let shared = NetworkManager()

    var page : Int = 1

    private enum userDefaultsKeys: String {
        case type
        case infoType
    }

    var type: NewsApiRouter {
        didSet {
            switch type {
            case .everything:
                break
            default:
                let defaults = UserDefaults.standard
                if let data = try? PropertyListEncoder().encode(type) {
                    defaults.set(data, forKey: userDefaultsKeys.type.rawValue)
                    defaults.synchronize()
                } else {
                    print("Error: unpossible to write type to user defaults")
                }
            }
        }
    }
    var NewsTypeInfo: NewsTypeAboutInfo {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(NewsTypeInfo.rawValue, forKey: userDefaultsKeys.infoType.rawValue)
            defaults.synchronize()
        }
    }

    // MARK: -   getFromUserDefaults
    func getFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let data = defaults.value(forKey: userDefaultsKeys.type.rawValue) as? Data,
            let storedNewsType = try? PropertyListDecoder().decode(NewsApiRouter.self, from: data) {
            type = storedNewsType
        } else {
            type = .topHeadlines(category: "general", country: "ua", source: nil, page: page)
            print("Error: unpossible to read type from user defaults")
        }
    }

    private init() {
        let storedInfoTypeRawValue = UserDefaults.standard.object(forKey: userDefaultsKeys.infoType.rawValue) as? Int
        if let rawValue = storedInfoTypeRawValue, let currentInfoType = NewsTypeAboutInfo(rawValue: rawValue) {
            NewsTypeInfo = currentInfoType
        } else {
            NewsTypeInfo = .headlines
            print("Error: unpossible to read infoType from user defaults")
        }

        let defaults = UserDefaults.standard
        if let data = defaults.value(forKey: userDefaultsKeys.type.rawValue) as? Data,
            let storedNewsType = try? PropertyListDecoder().decode(NewsApiRouter.self, from: data) {
            type = storedNewsType
        } else {
            type = .topHeadlines(category: "general", country: "ua", source: nil, page: page)
            print("Error: unpossible to read type from user defaults")
        }
    }
}
