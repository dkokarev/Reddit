//
//  Image.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct Image: Decodable {
    
    let id: String
    let source: Source
    let resolutions: [Source]
    var defaultThumbnailSource: Source? {
        return resolutions.last
    }
    
}
