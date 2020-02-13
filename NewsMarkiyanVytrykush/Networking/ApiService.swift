//
//  ApiService.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation


// MARK: -  ApiError
enum ApiError: Error {
    case unknown
    case notRightURL
}
// MARK: -  ApiResult
enum ApiResult<T: Codable> {
    case success(T)
    case failure(Error)
}
// MARK: -  ApiService
final class ApiService {
    
    private init() {}
    static let shared = ApiService()
    private(set) var task: URLSessionTask?
    
    func request<T: Codable>(request: URLRequest, type: T.Type, completion: @escaping (ApiResult<T>) -> ()) {
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? ApiError.unknown))
            }
        }
        task?.resume()
    }
}
