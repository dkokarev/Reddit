//
//  PostPage.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct Page {
    
    private(set) var after: String?
    private(set) var posts: [PostItem]
    
}

extension Page: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case after
        case posts = "children"
    }
    
    private enum DataKeys: String, CodingKey {
        case data
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: DataKeys.self)
        let pageValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        after = try pageValues.decode(String?.self, forKey: .after)
        posts = try pageValues.decode([Post].self, forKey: .posts)
    }
    
}
