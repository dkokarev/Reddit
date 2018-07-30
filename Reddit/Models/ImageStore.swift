//
//  ImageStore.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

struct ImageStore {
    
    // MARK: Public Methods
    
    func image(withURL url: URL) -> UIImage? {
        guard let path = path(withURL: url) else { return nil }
        return UIImage(contentsOfFile: path.path)
    }
    
    func saveImage(_ image: UIImage, withURL url: URL) {
        guard let path = path(withURL: url),
            let data = UIImageJPEGRepresentation(image, 1) else { return }
        
        try? data.write(to: path)
    }
    
    func path(withURL url: URL) -> URL? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        return directory.appendingPathComponent(url.lastPathComponent)
    }
    
}
