//
//  Source.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import CoreGraphics

enum URLError: Error {
    case wrongFormat
}

struct Source {
    
    let url: URL
    let size: CGSize
    
}

extension Source: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let urlString = try values.decode(String.self, forKey: .url).stringByDecodingHTMLEntities
        
        guard let url = URL(string: urlString) else {
            throw URLError.wrongFormat
        }
        
        let width = try values.decode(Int.self, forKey: .width)
        let height = try values.decode(Int.self, forKey: .height)
        
        self.url = url
        self.size = CGSize(width: width, height: height)
    }
    
}

extension Source: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url.absoluteString, forKey: .url)
        try container.encode(size.width, forKey: .width)
        try container.encode(size.height, forKey: .height)
    }
    
}
