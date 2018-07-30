//
//  ImageProvider.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCompletion = (URL, UIImage?) -> ()

class ImageProvider: NSObject {
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    // MARK: - Public Methods
    
    func image(withURL url: URL, completion: @escaping ImageCompletion) {
        if let operation = imageOperation(with: url) {
            operation.queuePriority = .veryHigh
        } else {
            let operation = ImageOperation(withURL: url)
            operation.queuePriority = .veryHigh
            operation.completionBlock = { [weak operation] in
                guard let strongOperation = operation else { return }
                
                DispatchQueue.main.async {
                    completion(strongOperation.url, strongOperation.image)
                }
            }
            
            if operationQueue.operations.count >= operationQueue.maxConcurrentOperationCount {
                operationQueue.operations.first?.cancel()
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    func setPriority(_ priority: Operation.QueuePriority, for url:URL) {
        if let operation = imageOperation(with: url) {
            operation.queuePriority = priority
        }
    }
    
    // MARK: - Public Methods
    
    private func imageOperation(with url: URL) -> ImageOperation? {
        return operationQueue.operations.first(where: { (operation) -> Bool in
            guard let imageOperation = operation as? ImageOperation else { return false }
            return imageOperation.url == url
        }) as? ImageOperation
    }
    
}
