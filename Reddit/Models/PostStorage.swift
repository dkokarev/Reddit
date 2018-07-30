//
//  PostStorage.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct PostStorage {
    
    private let selectedPostFilename = "selectedPost"
    
    var selectedPost: Post? {
        guard let url = path(withFilename: selectedPostFilename),
            let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        return try? JSONDecoder().decode(Post.self, from: data)
    }
    
    // MARK: Public Methods
    
    func save(post: Post?) {
        guard let url = path(withFilename: selectedPostFilename) else { return }
        
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        
        if let data = try? JSONEncoder().encode(post) {
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
    }
    
    func path(withFilename name: String) -> URL? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        return directory.appendingPathComponent(name, isDirectory: false)
    }
    
}
