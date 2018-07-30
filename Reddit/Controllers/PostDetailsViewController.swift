//
//  PostDetailsViewController.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

class PostDetailsViewController: UIViewController {
    
    @IBOutlet private(set) var imageView: UIImageView!
    private let imageProvider = ImageProvider()
    var post: Post?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage(fromPost: post)
    }
    
    // MARK: - IB Actions
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        if let image = imageView.image {
            shareImage(image: image)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadImage(fromPost post: Post?) {
        guard let url = post?.preview?.defaultImage?.source.url else { return }
        
        imageProvider.image(withURL: url) { [weak self] (imageUrl, image) in
            guard let strongSelf = self else { return }
            
            strongSelf.imageView.image = image
        }
    }
    
}
