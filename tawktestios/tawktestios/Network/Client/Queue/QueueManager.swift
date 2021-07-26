//
//  QueueManager.swift
//  tawktestios
//
//  Created by JMC on 25/7/21.
//

import Foundation


class DataManager {

    private let queueManager: QueueManager

    // MARK: - Init

    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }

    // MARK: - Retrieval

    func retrievalQuestions() {
        let operation = NetworkOperation()
//        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
}


class QueueManager {
    static let shared = QueueManager()

    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        return queue;
    }()

    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
}
