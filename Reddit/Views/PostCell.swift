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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        authorLabel.text = nil
        numberOfCommentsLabel.text = nil
    }
    
    func update(with post: Post) {
        titleLabel.text = post.title
        authorLabel.text = "Posted by \(post.author) \(post.date.timeAgoSinceNow())"
        numberOfCommentsLabel.text = String(post.numberOfComments) + " Comments"
    }
    
}
