//
//  PopUpViewController.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import UIKit

class PopUpViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var pickerView: UIPickerView!


    var delegate : CategoryValueChangeDelegate?
    
    var pressedButton: ParametersButton = .noButton
    var changedParameters: [String:String]?
    var newParameter: String?
    var filterValuesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - setup
    func setup() {
        
        switch pressedButton {
        case .categoryButton:
            filterValuesArray = Parameters.category.filterValues
            pickCurrentValue(type: Parameters.category)
        case .countryButton:
            filterValuesArray = Parameters.country.filterValues
            pickCurrentValue(type: Parameters.country)
        case .sourcesOrLanguageButton:
            sourcesOrLanguageSetup()
        default:
            break
        }
    }

    // MARK: - sourcesOrLanguageSetup
    func sourcesOrLanguageSetup() {
        if NetworkManager.shared.NewsTypeInfo == .headlines{
            filterValuesArray = Parameters.sources.filterValues
            pickCurrentValue(type: Parameters.sources)
        } else {
            filterValuesArray = Parameters.language.filterValues
            pickCurrentValue(type: Parameters.language)
        }
    }

    // MARK: - pickCurrentValue
    func pickCurrentValue(type: Parameters) {
        
        if let value = changedParameters?[type.rawValue] {
            newParameter = value
            let index = type.filterValues.firstIndex(of: value)
            pickerView.selectRow(index ?? 0, inComponent: 0, animated: false)
        }
    }



    // MARK: - IBAction
    @IBAction func doneButton(_ sender: Any) {
        delegate?.changeValue(val: newParameter)
        self.dismiss(animated: true)
    }
    
}




// MARK: - extension PopUpViewControllerDataSource
extension PopUpViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterValuesArray.count
    }
    
}


// MARK: - extension PopUpViewControllerDelegate
extension PopUpViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterValuesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            newParameter = filterValuesArray[row]
        } else {
            newParameter = nil
        }
    }
    
}
