//
//  PostController.swift
//  PostiOS24
//
//  Created by Cameron Milliken on 2/4/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class PostController {
    
    // MARK: - Properties
    static let baseUrl = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    // source of Truth
    static var posts: [Post] = []
    
    // MARK: - FetchFunctions
    static func fetchPosts(reset: Bool = true, completion: @escaping ()-> Void) {
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
        guard let unwrappedUrl = baseUrl else { completion() ; return }
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15"]
        
        let queryItems = urlParameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponents = URLComponents(url: unwrappedUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        
        guard let url = urlComponents?.url else { completion() ; return }
        let getterEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        //DataTask
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error in \(#function) : \(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data else { completion() ; return }
            let jsonDecoder = JSONDecoder()
            do {
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({ ($0.value) })
                posts.sort(by: { $0.timestamp > $1.timestamp })
                self.posts = posts
                completion()
            } catch {
                print("There was an error in \(#function) : \(error.localizedDescription)")
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    //Adds new Post
    static func addNewPostWith(username: String, text: String, completion: @escaping () -> Void) {
        let newPost = Post(username: username, text: text)
        var postData: Data
        do {
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(newPost)
        } catch {
            print("There was an error in \(#function) : \(error.localizedDescription)")
            completion()
            return
        }
        guard let unwrappedUrl = baseUrl else { completion() ; return }
        let postEndpoint = unwrappedUrl.appendingPathExtension("json")
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("There was an error in \(#function) : \(error.localizedDescription)")
                completion()
                return
            }
            print(response ?? "No response")
            guard let data = data else { completion() ; return }
            print(String(data: data, encoding: .utf8) ?? "There was an error")
            self.fetchPosts {
                completion()
            }
            }.resume()
    }
    
} //End of class
