//
//  ImageOperation.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

class ImageOperation: Operation {
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    let url: URL
    private(set) var image: UIImage?
    private weak var task: URLSessionDataTask?
    
    private(set) var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    // MARK: - Initialization
    
    init(withURL url: URL) {
        self.url = url
    }
    
    // MARK: - Public Methods
    
    override func start() {
        if self.isCancelled {
            state = .finished
            return
        }
        
        state = .executing
        
        image = ImageStorage().image(withURL: url)
        
        if image != nil {
            state = .finished
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            
            if let data = data, let image = UIImage(data: data) {
                ImageStorage().saveImage(image, withURL: strongSelf.url)
                strongSelf.image = image
            }
            
            strongSelf.state = .finished
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        
        task?.cancel()
    }
}
