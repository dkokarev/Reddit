//
//  ImageStore.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

struct ImageStorage: Storable {
    
    typealias Item = UIImage
    
    func save(_ item: Item, withFilename filename: String) {
        guard let url = path(forFilename: filename) else { return }
        
        removeItem(withFilename: filename)
        
        if let data = UIImageJPEGRepresentation(item, 1) {
            try? data.write(to: url)
        }
    }
    
    func getItem(withFilename filename: String) -> Item? {
        guard let url = path(forFilename: filename) else { return nil }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    func removeItem(withFilename filename: String) {
        guard let url = path(forFilename: filename) else { return }
        
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    func path(forFilename filename: String) -> URL? {
        return FileManager.default.url(forFilename: filename, directory: .cachesDirectory)
    }
    
}
