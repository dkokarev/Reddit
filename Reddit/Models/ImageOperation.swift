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
        
        image = ImageStore().image(withURL: url)
        
        guard image == nil, let data = try? Data(contentsOf: url) else {
            state = .finished
            return
        }
        
        image = UIImage(data: data)
        
        if image != nil {
            ImageStore().saveImage(image!, withURL: url)
        }
        
        state = .finished
    }
    
}
