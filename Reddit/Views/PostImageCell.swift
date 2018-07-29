//
//  PostImageCell.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

class PostImageCell: PostCell {
    
    @IBOutlet private(set) var previewImageView: UIImageView!
    @IBOutlet private(set) var imageAspectRatio: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        previewImageView.layer.cornerRadius = 10.0
    }
    
    override func update(with post: Post) {
        super.update(with: post)
        
        guard let size = post.preview?.defaultImage?.defaultThumbnailSource?.size else { return }
        
        previewImageView.removeConstraint(imageAspectRatio)
        imageAspectRatio = NSLayoutConstraint(item:         previewImageView,
                                              attribute:    .width,
                                              relatedBy:    .equal,
                                              toItem:       previewImageView,
                                              attribute:    .height,
                                              multiplier:   size.width / size.height,
                                              constant:     0.0)
        previewImageView.addConstraint(imageAspectRatio)
        
    }
    
}
