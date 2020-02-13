//
//  Category.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation


enum Parameters: String {

    case category
    case country
    case sources
    case language
    case searchingText = "q"
    case page

    var filterValues: [String] {
        switch self {
        case .category:
            return ["all","business","entertainment","general","health","science","sports","technology"]
        case .country:
            return ["all","ae","ar","at","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","ua","us","ve","za"]
        case .sources:
            return ["all","bbc-news","bbc-sport","cnn","focus","google-news","mtv-news","national-geographic","new-scientist","news24","reddit-r-all","the-sport-bible","time"]
        case .language:
            return ["all","ar","de","en","es","fr","he","it","nl","no","pt","ru","se","ud","zh"]
        default:
            return []
        }
    }
}

enum ParametersButton {
    case noButton
    case categoryButton
    case countryButton
    case sourcesOrLanguageButton
}
