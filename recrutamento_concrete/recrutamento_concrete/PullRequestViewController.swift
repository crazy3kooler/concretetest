//
//  PullRequestViewController.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 2/2/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class PullRequestViewController: UITableViewController {
    var repoName: String!
    var userName: String!
    let connector = APIConnector()
    let loader = GenericLoader()
    var pullRequests: [PullRequestModel]!
    let imageService = ImageCacheService()
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = repoName
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        loader.showSpinner(view)
        loadingPullRefresh()
        loadPRs()
    }
    
    /*
    * Denit for DGElasticPullToRefresh, temporary solution of the lib developer (I'm trying to fix too)
    * parameter: incremet page and APIConnector instance.
    */
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    /*
    * Load Pull request from repository from gitHub API and verify increment page.
    * necessary variables: userName(owner of the repository), repoName(repository name).
    */
    func loadPRs() {
        connector.getPullRequests(userName, repoName: repoName) { (result, error) -> () in
            if result?.count > 0 {
                self.pullRequests = result
                self.tableView.reloadData()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.loader.hideSpinner()
                self.tableView.dg_stopLoading()
            }
        }
    }
    
    /*
    * Loading pullRefresh lib in tableView.
    */
    func loadingPullRefresh() {
        self.loadingView.tintColor = Theme.Colors.PullRefreshLoading.color
        self.tableView!.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.pullRequests = nil
            self?.loadPRs()
            }, loadingView:  self.loadingView)
        Theme.Colors.PullRefreshBackground.color
         self.tableView!.dg_setPullToRefreshFillColor(Theme.Colors.PullRefreshBackground.color)
         self.tableView!.dg_setPullToRefreshBackgroundColor(self.tableView!.backgroundColor!)
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellPR", forIndexPath: indexPath) as! PullRequestTableViewCell
        cell.lblTitle.text = self.pullRequests[indexPath.row].title as String
        cell.lblDescription.text = self.pullRequests[indexPath.row].body! as String
        cell.lblUserName.text = self.pullRequests[indexPath.row].user_name! as String
        cell.imgAvatar.image = UIImage(named:"placeholder_avatar.png")
        cell.imgAvatar.layer.cornerRadius = 22.5;
        if let url = self.pullRequests[indexPath.row].avatar {
            if let img = imageService.getAvatarCache(url) {
                cell.imgAvatar.image = img
            } else {
                imageService.asyncLoadImageContent(url, completion: { (image) -> Void in
                    let ip = tableView.indexPathForCell(cell)
                    if indexPath.isEqual(ip) {
                        cell.imgAvatar.image = image
                    }
                })
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = self.pullRequests[indexPath.row].url {
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
       
    }
}
