//
//  ViewController.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import UIKit

class TopPostsViewController: UIViewController, Pageable {
    
    private let estimatedCellHeight: CGFloat = 130.0
    private let estimatedImageCellHeight: CGFloat = 330.0
    private let distanceToLoadNextPage: CGFloat = 300.0
    private let cellId = "PostCell"
    private let imageCellId = "PostImageCell"
    private let detailsSegue = "PostDetailsSegue"
    
    @IBOutlet private var tableView: UITableView!
    private(set) var marker: String?
    private weak var task: URLSessionDataTask?
    
    private var posts = [PostItem]()
    private lazy var imageProvider = ImageProvider()
    private lazy var loadingView = LoadingView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
    
    private(set) var loading = false {
        didSet {
            tableView.tableFooterView = loading == true ? loadingView : nil
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadNextPage(after: marker)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    deinit {
        task?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsSegue, let indexPath = tableView.indexPathForSelectedRow, let post = posts[indexPath.row] as? Post {
            if let controller = segue.destination as? PostDetailsViewController {
                controller.post = post
            }
        }
    }
    
    // MARK: - Pageable
    
    func loadNextPage(after: String?) {
        loading = true
        
        task = PostService.topPosts(after: after) { [weak self] page, error in
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
        
        if post.preview?.defaultImage?.defaultThumbnailSource?.url != nil {
            cell = tableView.dequeueReusableCell(withIdentifier: imageCellId) as! PostImageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PostCell
        }
        
        cell.update(with: post)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let post = posts[indexPath.row] as? Post,
              let url = post.preview?.defaultImage?.defaultThumbnailSource?.url else { return }
        
        imageProvider.image(withURL: url) { [weak self] (imageUrl, image) in
            guard let strongSelf = self,
                  let imageCell = cell as? PostImageCell ,
                  let indexPath = strongSelf.tableView.indexPath(for: cell),
                  let post = strongSelf.posts[indexPath.row] as? Post,
                  let url = post.preview?.defaultImage?.defaultThumbnailSource?.url,
                  url == imageUrl else { return }
            
            imageCell.previewImageView.image = image
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageCell = cell as? PostImageCell,
              imageCell.previewImageView.image == nil,
              let post = posts[indexPath.row] as? Post,
              let url = post.preview?.defaultImage?.defaultThumbnailSource?.url else { return }
        
        imageProvider.setPriority(.low, for: url)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row] as! Post
        
        if post.preview == nil {
            return estimatedCellHeight
        } else {
            return estimatedImageCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row] as! Post
        
        if post.preview?.defaultImage?.source != nil {
            self.performSegue(withIdentifier: detailsSegue, sender: nil)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension TopPostsViewController: UIScrollViewDelegate {
    
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
