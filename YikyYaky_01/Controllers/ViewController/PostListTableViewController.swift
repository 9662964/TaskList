//
//  PostListTableViewController.swift
//  YikyYaky_01
//
//  Created by iljoo Chae on 7/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit



class PostListTableViewController: UITableViewController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        fetchPosts()
    }
    
    //MARK:-Helper methods
    func fetchPosts() {
        PostController.sharedInstance.fetchAllPosts{(result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error \(error) - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Put your message here"
        }
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Enter your name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let postAction = UIAlertAction(title: "Post", style: .default) {(_) in
            guard let bodyText = alertController.textFields?[0].text,
                let authorText = alertController.textFields?[1].text,
                !bodyText.isEmpty, !authorText.isEmpty else {return}
            
            //MA
            PostController.sharedInstance.createPost(text: bodyText, author: authorText) { [weak self](result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("error-\(error)-\(error.localizedDescription)")
                    }
                }
                
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        
        self.present(alertController,animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.sharedInstance.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}

        let post = PostController.sharedInstance.posts[indexPath.row]
        cell.post = post

        return cell
    }
    


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let postToDelete = PostController.sharedInstance.posts[indexPath.row]
        if editingStyle == .delete {
        guard let index = PostController.sharedInstance.posts.firstIndex(of: postToDelete) else {return}
        
        PostController.sharedInstance.deletePost(post: postToDelete) { (result) in
            switch result {
            case .success(_):
                PostController.sharedInstance.posts.remove(at: index)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .failure(let error):
                print("Error \(error) - \(error.localizedDescription)")
            }
        }
        
            // Delete the row from the data source
        }
    }
    
    //MARK: Bar button item
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
        
        fetchPosts()
    }
    @IBAction func addBtnTapped(_ sender: Any) {
        presentAlertController(title: "YiKKKK YaKKKK", message: "Share your post!")
    }
    
    
    // MARK: - Navigation

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
    }
    

}//End of class
