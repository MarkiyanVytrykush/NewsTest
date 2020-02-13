//
//  DaterManger.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation


// MARK: -  extension DateManager
enum DateManager {

    private static let serverFormater: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        return formatter
    }()

   
    private static let displayFormater: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()


    enum DateType {
        case full
    }

    // MARK: -  static func date
    static func date(from string: String?) -> Date? {

        guard let string = string else { return nil }
        return serverFormater.date(from: string)
    }

    static func string(from date: Date?, type: DateType) -> String? {

        guard let date = date else { return nil }
        return formater(for: type).string(from: date)
    }

    private static func formater(for type: DateType) -> DateFormatter {
        switch type {
        case .full:
            return displayFormater
        }
    }
}
