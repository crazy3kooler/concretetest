//
//  recrutamento_concreteTests.swift
//  recrutamento_concreteTests
//
//  Created by Arilson Carmo on 1/27/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import XCTest
import UIKit
import recrutamento_concrete

class recrutamento_concreteTests: XCTestCase {
    
    var home: HomeViewController!
    
    class FakeAPIConnection: APIConnector {
        var getRepoWasCalled = false
        
        var resultRepoMocked: [RepositoryModel]? = [RepositoryModel(data: ["id" : "1","full_name" : "blabla", "name" : "Test" , "description" : "descriptiontest", "stargazers_count" : "123123", "forks_count" : "123123", "owner" : ["login" : "testeName", "avatar_url" : "http://densta-panels.com/wp-content/uploads/2014/02/test1.jpg"]])!]
        
        override func getJavaTopStars(increment: Bool, completionBlock: ([RepositoryModel]?, NSError?) -> ()) {
            getRepoWasCalled = true
            completionBlock(resultRepoMocked, nil)
        }
        
    }
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main",
            bundle: NSBundle(forClass: self.dynamicType))
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        home = navigationController.topViewController as! HomeViewController
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = home
    }
    
    func testRepoPopulating() {
        let fakeConnection = FakeAPIConnection()
        home.loadRepositories(true, connector: fakeConnection)

        XCTAssertTrue(fakeConnection.getRepoWasCalled)
        
        if let dataSource = home.repositoryData {
            XCTAssertEqual(fakeConnection.resultRepoMocked!, dataSource)
        } else {
            XCTFail("Data Source should not be nil!!!")
        }
    }
    
    func testPerformanceExample() {
        
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
