//
//  FileManagerExtension.swift
//  Reddit
//
//  Created by Danil Kokarev on 31.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

extension FileManager {
    
    func url(forFilename name: String, directory: FileManager.SearchPathDirectory = .documentDirectory) -> URL? {
        guard let directory = try? FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        
        return directory.appendingPathComponent(name, isDirectory: false)
    }
    
}
