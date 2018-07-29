//
//  Post.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct Post: PostItem {
    
    var id: String
    var author: String
    var numberOfComments: Int
    var date: Date
    var title: String
    var preview: Preview?
    
}

extension Post: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case numberOfComments = "num_comments"
        case date = "created"
        case title
        case preview
    }
    
    private enum DataKeys: String, CodingKey {
        case data
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: DataKeys.self)
        let postValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        id = try postValues.decode(String.self, forKey: .id)
        author = try postValues.decode(String.self, forKey: .author)
        numberOfComments = try postValues.decode(Int.self, forKey: .numberOfComments)
        title = try postValues.decode(String.self, forKey: .title)
        preview = try? postValues.decode(Preview.self, forKey: .preview)
        let timeInterval = try postValues.decode(TimeInterval.self, forKey: .date)
        date = Date(timeIntervalSince1970: timeInterval)
    }

}
