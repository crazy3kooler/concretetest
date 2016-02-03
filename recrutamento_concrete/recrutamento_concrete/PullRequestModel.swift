//
//  PullRequestModel.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 2/2/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import Foundation

class PullRequestModel {
    var id: Int!
    var url: String?
    var title: String!
    var body: String?
    var user_name: String!
    var avatar: NSURL!
    
    init?(data: [String: AnyObject]!) {
        id = data["id"] as? Int
        url = data["html_url"] as? String
        title = data["title"] as? String
        body = data["body"] as? String
        if let user = data["user"] as? [String: AnyObject] {
            user_name = user["login"] as? String
            avatar = NSURL(string: user["avatar_url"] as! String)
        }
    }
}
