//
//  CategoryViewController.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import UIKit


protocol CategoryParameterDelegate {
    func tableViewUpdateWithNewFilters()
}

protocol CategoryValueChangeDelegate {
    func changeValue(val: String?)
}


class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryShow: UIButton!
    @IBOutlet weak var countryShow: UIButton!
    @IBOutlet weak var sourceOrLanguageShow: UIButton!

    var parameters = [String:String]()
    var pressedButton: ParametersButton = .noButton
    
    var delegate: CategoryParameterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - setup
    func setup() {

        parameters = NetworkManager.shared.type.queryParameters

        setCategoryButton()
        setCountryButton()
        setSourceOrLanguageButton()

    }
    // MARK: - setCategoryButton
    func setCategoryButton() {
        if let category = parameters[Parameters.category.rawValue] {
            categoryShow.setTitle("Category: \(category)", for: .normal)
        } else {
            categoryShow.setTitle("Category: \(Parameters.category.filterValues[0])", for: .normal)
        }
    }

     // MARK: - setCountryButton
    func setCountryButton() {
        if let country = parameters[Parameters.country.rawValue] {
            countryShow.setTitle("Country: \(country)", for: .normal)
        } else {
            countryShow.setTitle("Country: \(Parameters.country.filterValues[0])", for: .normal)
        }
    }
    // MARK: - setSourceOrLanguageButton
    func setSourceOrLanguageButton() {
        switch NetworkManager.shared.NewsTypeInfo {
        case .headlines:
            if let source = parameters[Parameters.sources.rawValue] {
                sourceOrLanguageShow.setTitle("Source: \(source)", for: .normal)
            } else {
                sourceOrLanguageShow.setTitle("Source: \(Parameters.sources.filterValues[0])", for: .normal)
            }
        case .publishers:
            if let language = parameters[Parameters.language.rawValue] {
                sourceOrLanguageShow.setTitle("Language: \(language)", for: .normal)
            } else {
                sourceOrLanguageShow.setTitle("Language: \(Parameters.language.filterValues[0])", for: .normal)
            }
        }
    }
    // MARK: - setType
    func setType() {
        switch NetworkManager.shared.NewsTypeInfo {
        case .headlines:
            if parameters[Parameters.category.rawValue] == nil && parameters[Parameters.country.rawValue] == nil && parameters[Parameters.sources.rawValue] == nil {
                NetworkManager.shared.type = .topHeadlines(category: Parameters.category.filterValues[3],
                                                           country: nil,
                                                           source: nil,
                                                           page: 1)
            } else {
                NetworkManager.shared.type = .topHeadlines(category: parameters[Parameters.category.rawValue],
                                                           country: parameters[Parameters.country.rawValue],
                                                           source: parameters[Parameters.sources.rawValue],
                                                           page: 1)
            }
        case .publishers:
            NetworkManager.shared.type = .sources(category: parameters[Parameters.category.rawValue],
                                                  country: parameters[Parameters.country.rawValue],
                                                  language: parameters[Parameters.language.rawValue])
        }
    }


     // MARK: - IBActions
    @IBAction func category(_ sender: Any) {
        buttonClicked(button: .categoryButton)
    }

    @IBAction func country(_ sender: Any) {
        buttonClicked(button: .countryButton)
    }

    @IBAction func source(_ sender: Any) {
        buttonClicked(button: .sourcesOrLanguageButton)
    }

    func buttonClicked(button: ParametersButton) {
        pressedButton = button
        performSegue(withIdentifier: "showPopUp", sender: self)
    }

    @IBAction func OkAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        setType()
        PageManager.shared.resetPageCounting()
        delegate?.tableViewUpdateWithNewFilters()
    }




    // MARK: - categorySelect
    func categorySelect(choosenParameter: String?) {
        parameters[Parameters.category.rawValue] = choosenParameter
        switch NetworkManager.shared.NewsTypeInfo {
        case .headlines:
            if choosenParameter != nil {
                sourceOrLanguageShow.setTitle("Source: \(Parameters.sources.filterValues[0])", for: .normal)
                parameters[Parameters.sources.rawValue] = nil
            }
        default:
            break
        }
        setCategoryButton()
    }

    func countrySelect(choosenParameter: String?) {
        parameters[Parameters.country.rawValue] = choosenParameter
        switch NetworkManager.shared.NewsTypeInfo {
        case .headlines:
            if choosenParameter != nil {
                sourceOrLanguageShow.setTitle("Source: \(Parameters.sources.filterValues[0])", for: .normal)
                parameters[Parameters.sources.rawValue] = nil
            }
        default:
            break
        }
        setCountryButton()
    }

    // MARK: - sourceSelect
    func sourceSelect(choosenParameter: String?) {
        switch NetworkManager.shared.NewsTypeInfo {
        case .headlines:
            parameters[Parameters.sources.rawValue] = choosenParameter
            if choosenParameter != nil {
                sourceOrLanguageShow.setTitle("Category: \(Parameters.category.filterValues[0])", for: .normal)
                sourceOrLanguageShow.setTitle("Country: \(Parameters.country.filterValues[0])", for: .normal)
                parameters[Parameters.category.rawValue] = nil
                parameters[Parameters.country.rawValue] = nil
                setCategoryButton()
                setCountryButton()
            }
        case .publishers:
            parameters[Parameters.language.rawValue] = choosenParameter
        }
        setSourceOrLanguageButton()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PopUpViewController {
            destination.pressedButton = pressedButton
            destination.changedParameters = parameters
            destination.delegate = self
        }
    }

}




// MARK: - CategoryValueChangeDelegate
extension CategoryViewController: CategoryValueChangeDelegate {

    func changeValue(val: String?) {
        switch pressedButton {
        case .categoryButton:
            categorySelect(choosenParameter: val)
        case .countryButton:
            countrySelect(choosenParameter: val)
        case .sourcesOrLanguageButton:
            sourceSelect(choosenParameter: val)
        default:
            break
        }
    }
}



