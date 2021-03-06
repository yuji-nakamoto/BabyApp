//
//  MyPageViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import GoogleMobileAds

class MyPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var user = User()
    private var followCount = Follow()
    private var followerCount = Follower()
    private var tweets = [Tweet]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
//        testBanner()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFollowCount()
        fetchFollwerCount()
        fetchMyTweet()
        fetchUser()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        indicator.startAnimating()
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.resetBadge(self.user)
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    private func fetchFollowCount() {
        
        Follow.fetchFollowCount(User.currentUserId()) { [self] (follow) in
            self.followCount = follow
            self.tableView.reloadData()
        }
    }
    
    private func fetchFollwerCount() {
        
        Follower.fetchFollowerCount(User.currentUserId()) { (follower) in
            self.followerCount = follower
            self.tableView.reloadData()
        }
    }
    
    private func fetchMyTweet() {
        
        tweets.removeAll()
        Tweet.fetchMyTweet(User.currentUserId()) { (tweet) in
            self.tweets.insert(tweet, at: 0)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func resetBadge(_ user: User) {
        
        let totalAppBadgeCount = user.appBadgeCount - user.myPageBadgeCount
        
        updateUser(withValue: [MYPAGE_BADGE_COUNT: 0, APP_BADGE_COUNT: totalAppBadgeCount])
        UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TweetCommentVC" {
            let tweetCommentVC = segue.destination as! TweetCommentViewController
            let tweetId = sender as! String
            tweetCommentVC.tweetId = tweetId
        }
    }
    
    private func setup() {
        
        tableView.separatorColor = .systemGray
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        navigationItem.title = "マイページ"
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/6418139939"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

// MARK: - Table view

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPageTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! TweetTableViewCell
        
        if indexPath.row == 0 {
            cell.configureCell(self.user, self.followCount, self.followerCount)
            return cell
        }
        
        cell2.myPageVC = self
        cell2.currentUser = user
        cell2.tweet = tweets[indexPath.row - 1]
        cell2.configureLikeCount()
        cell2.configureCell(tweets[indexPath.row - 1], self.user)
        return cell2
    }
}
