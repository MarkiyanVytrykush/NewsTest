//
//  ImageTool.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import UIKit

class UIRemoteImageView: UIImageView {

    private static let placeholder = UIImage(named: "placeholder")?.reSizeImage()
    private var currentURL: URL?
    private var currentProcess: DispatchWorkItem?

    // MARK: -  setImage
    func setImage(from url: URL, placeholder: UIImage? = UIRemoteImageView.placeholder) {

        self.image = placeholder

        currentURL = url

        currentProcess = ServiceToImage.getImage(imageURL: url) { (image, url) in
            if self.currentURL == url {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                self.currentProcess?.cancel()
            }
        }
    }
}
