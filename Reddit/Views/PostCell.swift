//
//  PostCell.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var authorLabel: UILabel!
    @IBOutlet private(set) var numberOfCommentsLabel: UILabel!
    
    func update(with post: Post) {
        titleLabel.text = post.title
        authorLabel.text = "Posted by " + post.author
        numberOfCommentsLabel.text = String(post.numberOfComments) + " Comments"
    }
    
}
