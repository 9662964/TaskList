//
//  PostTableViewCell.swift
//  YikyYaky_01
//
//  Created by iljoo Chae on 7/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    //MARK: Outlet
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var pointTotalLabel: UILabel!
    
    //MARK: Properties
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Action
    @IBAction func upBtnTapped(_ sender: Any) {
        
        guard let post = post else {return}
        post.score += 1
        PostController.sharedInstance.updatePost(post: post) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPost):
                    self.pointTotalLabel.text = "\(updatedPost.score)"
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }
    @IBAction func downBtnTapped(_ sender: Any) {
        guard let post = post else {return}
        post.score -= 1
        PostController.sharedInstance.updatePost(post: post) { (result) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let updatedPost):
                    self.pointTotalLabel.text  = "\(updatedPost.score)"
                case .failure(let error):
                    print("error \(error)")
                }
            }
        }
        
    }
    
    func updateViews() {
        guard let post = post else {return}
        postTextLabel.text = "\(post.text) -  \(post.author)"
        pointTotalLabel.text = "\(post.score)"
        
    }
    
    
}
