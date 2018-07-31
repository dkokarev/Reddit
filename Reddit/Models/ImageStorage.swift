//
//  ImageStore.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

struct ImageStorage {
    
    // MARK: Public Methods
    
    func image(withFilename filename: String) -> UIImage? {
        guard let path = path(withFilename: filename) else { return nil }
        
        return UIImage(contentsOfFile: path.path)
    }
    
    func saveImage(_ image: UIImage, withFilename filename: String) {
        guard let path = path(withFilename: filename),
              let data = UIImageJPEGRepresentation(image, 1) else { return }
        
        try? data.write(to: path)
    }
    
    func path(withFilename filename: String) -> URL? {
        guard let directory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        
        return directory.appendingPathComponent(filename)
    }
    
}
