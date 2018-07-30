//
//  Preview.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct Preview: Codable {
    
    let images: [Image]
    let enabled: Bool
    var defaultImage: Image? {
        return images.first
    }
    
}
