//
//  Extensions.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import UIKit

// MARK: -  extension alert
extension UIViewController {
    func alert(title: String?, message: String?, button: String?, action: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -  extension getViewController
extension UIStoryboard {

    func getVC<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
// MARK: -  extension get dequeueReusableCell
extension UITableView {

    func getCell<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
}

// MARK: -  extension UIImage
extension UIImage {

    // MARK: -  reSizeImage
    func reSizeImage()->UIImage {
        let newWidth = UIScreen.main.bounds.size.width
        let newHeight = newWidth*0.6
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage != nil ? newImage! : self
    }

}

