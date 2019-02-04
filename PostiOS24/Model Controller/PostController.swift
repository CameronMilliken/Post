//
//  PostController.swift
//  PostiOS24
//
//  Created by Cameron Milliken on 2/4/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class PostController {
    
    //Base URL/API URL
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    //Source of Truth
    var posts = [Post]()
    
    func fetchPosts(completion: @escaping ((_ posts: [Post]) -> Void)) {
        guard let baseURL = baseURL else {fatalError("🤬 URL optional is having issues!")}
        let getterPoint = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: getterPoint)
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            do {
                if let error = error {throw error}
                guard let data = data else {throw NSError()}
                
                //Decodes the data
                let jsonDeocder = JSONDecoder()
                let postsDictionary = try! jsonDeocder.decode([String: Post].self, from: data)
                var posts = postsDictionary.compactMap({$0.value})
                posts.sort(by: {$0.timestamp > $1.timestamp})
                self.posts = posts
                completion([])
                return
                
            } catch {
                //Handle data and error accordingly
                print("🐸🔫 Error retreiving posts from \(request)")
                //Complete with posts
                completion([])
                return
            }
        }
        dataTask.resume()
    }
    
}
