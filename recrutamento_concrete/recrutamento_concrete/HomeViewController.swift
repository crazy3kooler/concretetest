//
//  ViewController.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 1/27/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import Font_Awesome_Swift

public class HomeViewController: UITableViewController {

    let loader = GenericLoader()
    var repositoryData: [RepositoryModel]!
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    let imageService = ImageCacheService()
    
    override public func viewDidLoad() {
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        loader.showSpinner(view)
        loadRepositories(true)
    }
    
    override public func viewWillAppear(animated: Bool) {
        loadingPullRefresh()
    }
    
    /*
    * Denit for DGElasticPullToRefresh, temporary solution of the lib developer (I'm trying to fix too)
    * parameter: incremet page and APIConnector instance.
    */
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    /*
    * Load repositories from gitHub API and verify increment page.
    * parameter: incremet page and APIConnector instance.
    */
    func loadRepositories(increment: Bool, connector: APIConnector = APIConnector()) {
        connector.getJavaTopStars(increment) { (result, error) -> () in
            if let starList = result {
                if self.repositoryData != nil && increment == true {
                    self.repositoryData.appendContentsOf(starList)
                } else{
                     self.repositoryData = starList
                }
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.reloadData()
                self.loader.hideSpinner()
                self.tableView!.dg_stopLoading()
            } else if let _ = error {
                self.tableView!.dg_stopLoading()
                self.loader.hideSpinner()
                GenericAlert().showAlert("Error", stringMessage: "Error on get repositories info from Github server. We will try to get again OK?",
                    completion: { () -> Void in
                        self.loader.showSpinner(self.view)
                        self.loadRepositories(false)
                })

            }
        }
    }
    
    /*
    * Loading pullRefresh lib in tableView.
    */
    func loadingPullRefresh() {
        tableView.dg_removePullToRefresh()
        loadingView.tintColor = Theme.Colors.PullRefreshLoading.color
        tableView!.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.repositoryData = nil
            self?.loadRepositories(false)
            }, loadingView: loadingView)
        Theme.Colors.PullRefreshBackground.color
        tableView!.dg_setPullToRefreshFillColor(Theme.Colors.PullRefreshBackground.color)
        tableView!.dg_setPullToRefreshBackgroundColor(tableView!.backgroundColor!)
    }
    
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryData?.count ?? 0
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath) as! RepositoryTableViewCell
        
        if repositoryData != nil {
            cell.lblRepositoryName.text = repositoryData[indexPath.row].repository_name
            cell.lblDescription.text = repositoryData[indexPath.row].repo_description
            cell.lblFork.setFAText(prefixText: "", icon: FAType.FACodeFork, postfixText: " \(String(repositoryData[indexPath.row].forks_count))", size: 15)
            cell.lblStar.setFAText(prefixText: "", icon: FAType.FAStar, postfixText: " \(String(repositoryData[indexPath.row].stargazers_count))", size: 15)
            cell.lblUserName.text = repositoryData[indexPath.row].login_name
            cell.imgAvatar.layer.masksToBounds = true
            cell.imgAvatar.image = UIImage(named: "placeholder_avatar.png")
            cell.imgAvatar.layer.cornerRadius = 27.5;
            
            if let url = self.repositoryData[indexPath.row].avatar {
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
        }
        return cell
    }
    
    /*
    * Function to implement endless scroll
    */
    override public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.repositoryData != nil && self.repositoryData.count > 3 {
            let offsetY = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            if (offsetY > contentHeight - (scrollView.frame.size.height - 5))
            {
                self.loader.showSpinner(self.view)
                self.loadRepositories(true)
            }
        }
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.repositoryData {
            performSegueWithIdentifier("pullSegue", sender: self)
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PullRequestViewController {
            if let row  = tableView.indexPathForSelectedRow?.row {
                destination.repoName = self.repositoryData[row].repository_name
                destination.userName = self.repositoryData[row].login_name
            }
        }
    }
}

