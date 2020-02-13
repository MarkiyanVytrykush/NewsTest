//
//  ServiceToImage.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation
import UIKit



class ServiceToImage {

    private static var imageCache = NSCache<NSString,UIImage>()

    private enum imageServiceErrors: Error {
        case unpossibleToGetDataFromURL
        case unpossibleToDownloadImage
    }

    // MARK: -  downloadImage
    private static func downloadImage(imageURL: URL,_ completion: @escaping (_ result: DownloadResult)->()) -> DispatchWorkItem {
        let downloadWorkItem = DispatchWorkItem{
            if let data = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: data)?.reSizeImage() {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
                        completion(.success(image))
                    }
                } else {
                    completion(.failure(.unpossibleToDownloadImage))
                }
            } else {
                completion(.failure(.unpossibleToGetDataFromURL))
            }
        }
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: downloadWorkItem)
        return downloadWorkItem
    }

    private enum DownloadResult {
        case success(UIImage)
        case failure(imageServiceErrors)
    }

    // MARK: -   getImage
    static func getImage(imageURL: URL, completion: @escaping (_ image: UIImage?,_ url: URL)->()) -> DispatchWorkItem? {
        if let image = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(image, imageURL)
            return nil
        } else {
            let workItem = downloadImage(imageURL: imageURL) { (result) in
                switch result {
                case .success(let image):
                    completion(image,imageURL)
                case .failure(let error):
                    print("Error with image: \(error)")
                }
            }
            return workItem
        }
    }


}
