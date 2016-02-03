//
//  RepositoryModel.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 1/27/16.
//  Copyright © 2016 arilson. All rights reserved.
//


import Foundation


class RepositoryModel: NSObject {
    var id: Int!
    var repository_name: String!
    var full_name: String!
    var repo_description: String?
    var stargazers_count: Int! = 0
    var forks_count: Int! = 0
    var avatar: NSURL?
    var login_name: String?
    
     init?(data: [String : AnyObject?]) {
        id = data["id"] as? Int
        
        repository_name =  data["name"] as? String
        full_name = data["full_name"] as? String
        repo_description = data["description"] as? String
        stargazers_count = data["stargazers_count"] as? Int
        forks_count = data["forks_count"] as? Int
        if let userInfo = data["owner"] as? [String: AnyObject] {
            login_name = userInfo["login"] as? String
            avatar = NSURL(string: userInfo["avatar_url"] as! String)
        }
    }
    
    
}