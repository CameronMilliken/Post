//
//  Post.swift
//  PostiOS24
//
//  Created by Cameron Milliken on 2/4/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

struct topLevelDictionary: Codable {
    let posts: [Post]
}

struct Post: Codable {
    let username: String
    let text: String
    var timestamp = TimeInterval()
    
//    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970){
//        self.username = username
//        self.text = text
//        self.timestamp = timestamp
//    }
}
