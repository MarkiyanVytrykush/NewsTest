//
//  OpenSafari.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import SafariServices

class Safari {
    private init() {}
    static let shared = Safari()

    // MARK: -   showPageInSafari
    func showPage(from url: URL?, sender: UIViewController) {
        if let url = url {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.delegate = sender as? SFSafariViewControllerDelegate

            sender.present(vc, animated: true)
        }
    }
}
