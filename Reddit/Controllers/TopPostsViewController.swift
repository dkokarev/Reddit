//
//  ViewController.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import UIKit

class TopPostsViewController: UIViewController {
    
    private let estimatedCellHeight: CGFloat = 130.0
    private let estimatedImageCellHeight: CGFloat = 330.0
    private let distanceToLoadNextPage: CGFloat = 300.0
    private let cellId = "PostCell"
    private let imageCellId = "PostImageCell"
    
    @IBOutlet private var tableView: UITableView!
    private var posts = [PostItem]()
    private(set) var loading = false
    private(set) var marker: String?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Reddit"
        
        loadNextPage(after: marker)
    }
    
    // MARK: - Pageable
    
    func loadNextPage(after: String?) {
        loading = true
        _ = PostService.topPosts(after: after) { [weak self] page, error in
            guard let strongSelf = self else { return }
            
            strongSelf.loading = false
            
            guard page != nil else { return }
            
            strongSelf.marker = page!.after
            strongSelf.posts.append(contentsOf: page!.posts)
            strongSelf.tableView.reloadData()
        }
    }

}

extension TopPostsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row] as! Post
        let cell: PostCell
        
        if post.preview == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PostCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: imageCellId) as! PostImageCell
        }
        
        cell.update(with: post)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row] as! Post
        
        if post.preview == nil {
            return estimatedCellHeight
        } else {
            return estimatedImageCellHeight
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loading == true || marker == nil {
            return
        }
        
        let distanceToTheEnd = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height
        
        if distanceToTheEnd < distanceToLoadNextPage {
            loadNextPage(after: marker)
        }
    }
    
}
