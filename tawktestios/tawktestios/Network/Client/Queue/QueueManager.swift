//
//  QueueManager.swift
//  tawktestios
//
//  Created by JMC on 25/7/21.
//

import Foundation

class QueueManager {
    static let shared = QueueManager()

    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue;
    }()

    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
}
