//
//  OtherViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit
import GoogleMobileAds

class OtherViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var user = User()
    private var currentUser = User()
    private var follow = Follow()
    private var followCount = Follow()
    private var followerCount = Follower()
    private var followOtherCount = Follow()
    private var checkFollow = Follow()
    private var tweets = [Tweet]()
    private var block = Block()
    var userId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        fetchUser()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFollow()
        fetchFollowCount()
        fetchFollwerCount()
        fetchOtherFollowCount()
        fetchOtherTweet()
        fetchBlockUser()
        checkIsFollow()
        fetchCurrentUser()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func followButtobPressed(_ sender: Any) {
        performSegue(withIdentifier: "FollowVC", sender: userId)
    }
    
    @IBAction func followerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "FollowerVC", sender: userId)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (currentUser) in
            self.currentUser = currentUser
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser() {
        
        indicator.startAnimating()
        User.fetchBlockUser(userId) { (user) in
            self.user = user
            self.navigationItem.title = "\(user.username ?? "")"
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    private func fetchFollow() {
        
        Follow.fetchFollow(userId) { (follow) in
            self.follow = follow
            self.tableView.reloadData()
        }
    }
    
    private func fetchFollowCount() {
        
        Follow.fetchFollowCount(User.currentUserId()) { [self] (follow) in
            self.followCount = follow
            self.tableView.reloadData()
        }
    }
    
    private func fetchOtherFollowCount() {
        
        Follow.fetchFollowCount(userId) { [self] (follow) in
            self.followOtherCount = follow
            self.tableView.reloadData()
        }
    }
    
    private func fetchFollwerCount() {
        
        Follower.fetchFollowerCount(userId) { (follower) in
            self.followerCount = follower
            self.tableView.reloadData()
        }
    }
    
    private func fetchOtherTweet() {
        
        tweets.removeAll()
        Tweet.fetchMyTweet(userId) { (tweet) in
            self.tweets.insert(tweet, at: 0)
            self.tableView.reloadData()
        }
    }
    
    private func fetchBlockUser() {
        
        Block.fetchBlockUser(userId: userId) { (block) in
            self.block = block
            self.tableView.reloadData()
        }
    }
    
    private func checkIsFollow() {
        
        Follow.checkFollow(userId) { (check) in
            self.checkFollow = check
        }
    }
    
    // MARK: - Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FollowVC" {
            let followVC = segue.destination as! FollowTableViewController
            let userId = sender as! String
            followVC.userId = userId
        }
        
        if segue.identifier == "FollowerVC" {
            let followerVC = segue.destination as! FollowerTableViewController
            let userId = sender as! String
            followerVC.userId = userId
        }
        
        if segue.identifier == "TweetCommentVC" {
            let tweetCommentVC = segue.destination as! TweetCommentViewController
            let tweetId = sender as! String
            tweetCommentVC.tweetId = tweetId
        }
        
        if segue.identifier == "ReportVC" {
            let reportVC = segue.destination as! ReportTableViewController
            let userId = sender as! String
            reportVC.userId = userId
        }
        
        if segue.identifier == "BlockVC" {
            let blockVC = segue.destination as! BlockTableViewController
            let userId = sender as! String
            blockVC.userId = userId
        }
    }
    
    private func setup() {
        
        tableView.separatorColor = .systemGray
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/6418139939"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension OtherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPageTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! TweetTableViewCell
        
        if indexPath.row == 0 {
            cell.otherVC = self
            cell.block = self.block
            cell.user = self.user
            cell.currentUser = self.currentUser
            cell.follow = self.follow
            cell.followCount = self.followCount
            cell.followerCount = self.followerCount
            cell.configureOtherCell(self.user, self.follow, self.followerCount, self.followOtherCount, self.checkFollow)
            return cell
        }
        
        cell2.otherVC = self
        cell2.user = self.user
        cell2.tweet = tweets[indexPath.row - 1]
        cell2.configureLikeCount()
        cell2.configureCell(tweets[indexPath.row - 1], self.user)
        return cell2
    }
}
