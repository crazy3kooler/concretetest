//
//  APIConnector.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 1/27/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import Foundation
import Alamofire

class APIConnector {
    var page = 0
    let endpoint = APIInfo.url
    
    func createRequestPath(requestUrl: String) -> String {
        return  endpoint + requestUrl
    }
    
    func getJavaTopStars(increment: Bool, completionBlock: ([RepositoryModel]?, NSError?) -> ()) {
        if increment {
            page = page + 1
        } else {
            page = 1
        }
        let request = createRequestPath("search/repositories?q=language:Java&sort=stars&page=" + String(page))
        Alamofire.request(.GET, request).responseJSON { response in
            switch response.result {
            case .Success:
                if  let data = response.result.value! as? [String:AnyObject] {
                    if let items = data["items"] as? [[String:AnyObject]] {
                        var list:[RepositoryModel] = []
                        for item in items {
                            if let s = RepositoryModel(data: item) {
                                list.append(s)
                            }
                        }
                        completionBlock(list, nil)
                    }
                }
            case .Failure(let error):
                completionBlock(nil, error)
            }
        }
    }
    
    func getPullRequests(username: String, repoName: String, completionBlock: ([PullRequestModel]?, NSError?) -> ()){
        let request = createRequestPath(String(format: "repos/%@/%@/pulls", arguments: [username, repoName]))
        Alamofire.request(.GET, request).responseJSON { response in
            switch response.result {
            case .Success:
                if  let entries = response.result.value as? [[String:AnyObject]] {
                    var list:[PullRequestModel] = []
                    for entry in entries {
                        if let e = PullRequestModel(data: entry) {
                            list.append(e)
                        }
                    }
                    completionBlock(list, nil)
                }
            case .Failure(let error):
                completionBlock(nil, error)
            }
        }

        
    }
}