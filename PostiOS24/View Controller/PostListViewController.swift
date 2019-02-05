//
//  PostListViewController.swift
//  PostiOS24
//
//  Created by Cameron Milliken on 2/4/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = PostController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username): \(Date.init(timeIntervalSince1970: post.timestamp))"
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // End of Class

extension PostListViewController {
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "Add new post", message: nil, preferredStyle: .alert)
        alertController.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Username"
        }
        alertController.addTextField { (messageTextField) in
            messageTextField.placeholder = "Message"
        }
        guard let userTextField = alertController.textFields?[0].text,
            let messageTextField = alertController.textFields?[1].text else { return }
        let postAlertAction = UIAlertAction(title: "Post", style: .default) { (_) in
            if !userTextField.isEmpty, !messageTextField.isEmpty {
                PostController.addNewPostWith(username: userTextField, text: messageTextField, completion: {
                    self.reloadInputViews()
                })
            } else {
                self.presentErrorAlert()
            }
        }
        let dimissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(postAlertAction)
        alertController.addAction(dimissAction)
        present(alertController, animated: true)
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Missing Information", message: "Please try again", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Try Again", style: .default) { (_) in
            self.presentNewPostAlert()
        }
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
        
    }
}
