//
//  ViewController.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import UIKit

class TopPostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = PostService.topPosts(after: nil) { posts, error in
            print(posts!)
        }
    }

}

