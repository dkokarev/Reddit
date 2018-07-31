//
//  PostStorage.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct PostStorage: Storable {
    
    typealias Item = Post
    
    func save(_ item: Item, withFilename filename: String) {
        guard let url = path(forFilename: filename) else { return }
        
        removeItem(withFilename: filename)
        
        if let data = try? JSONEncoder().encode(item) {
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
    }
    
    func getItem(withFilename filename: String) -> Item? {
        guard let url = path(forFilename: filename),
            let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        return try? JSONDecoder().decode(Post.self, from: data)
    }
    
    func removeItem(withFilename filename: String) {
        guard let url = path(forFilename: filename) else { return }
        
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    func path(forFilename filename: String) -> URL? {
        return FileManager.default.url(forFilename: filename)
    }
    
}
