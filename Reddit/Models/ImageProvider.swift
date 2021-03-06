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
    
    static let shared = ImageProvider()
    
    private let queue = DispatchQueue(label: "com.reddit.image")
    
    private lazy var session: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 5
        return URLSession(configuration: configuration)
    }()
    
    // MARK: - Public Methods
    
    func image(withURL url: URL, completion: @escaping ImageCompletion) {
        queue.async { [weak self] in
            if let image = ImageStorage().getItem(withFilename: String.filename(from: url)) {
                DispatchQueue.main.async { completion(url, image) }
                return
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.existingTask(with: url) { task in
                if let task = task {
                    task.priority = 1.0
                } else {
                    strongSelf.downloadImage(withUrl: url, completion: completion)
                }
            }
        }
    }
    
    func setPriority(_ priority: Float, for url:URL) {
        existingTask(with: url) { task in
            if let task = task {
                task.priority = priority
            }
        }
    }
    
    func cancelTask(withUrl url: URL) {
        existingTask(with: url) { task in
            if let task = task {
                task.cancel()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func downloadImage(withUrl url: URL, completion: @escaping ImageCompletion) {
        let filename = String.filename(from: url)
        
        guard let path = FileManager.default.url(forFilename: filename, directory: .cachesDirectory) else {
            DispatchQueue.main.async { completion(url, nil) }
            return
        }
        
        let task = session.downloadTask(with: url, completionHandler: { [weak self] localUrl, _, _ in
            guard let localUrl = localUrl,
                  let strongSelf = self else {
                    DispatchQueue.main.async { completion(url, nil) }
                    return
            }
            
            var image: UIImage? = nil
            
            strongSelf.queue.sync {
                if (try? FileManager.default.moveItem(at: localUrl, to: path)) != nil {
                    image = ImageStorage().getItem(withFilename: filename)
                }
            }
            
            DispatchQueue.main.async { completion(url, image) }
        })
        
        task.priority = 1.0
        task.resume()
    }
    
    private func existingTask(with url: URL, completion: @escaping (URLSessionDownloadTask?) -> ()) {
        return session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            completion(downloadTasks.first(where: { (task) -> Bool in
                if let originUrl = task.originalRequest?.url {
                    return originUrl == url
                }
                return false
            }))
        }
    }
    
}
