//
//  CancelTaskManager.swift
//  NewsMarkiyanVytrykush
//
//  Created by Nanter on 2/12/20.
//  Copyright © 2020 Markiyan Vytrykush. All rights reserved.
//

import Foundation

class TaskManager {

    static let shared = TaskManager()
    private init(){}

    let cancelledErrorDescription = "cancelled"

    func cancelTask(task: URLSessionTask?) {
        task?.cancel()
    }
}
