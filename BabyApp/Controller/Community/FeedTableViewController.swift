//
//  FeedTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class FeedTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var plusBackView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var tweets = [Tweet]()
    private var tweet = Tweet()
    private var follows = [Follow]()
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()        
        setup()
        fetchFollows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        fetchFeedTweet()
    }
    
    // MARK: - Actions
    
    @objc func refreshTableView(){
        UserDefaults.standard.set(true, forKey: ON_REFRESH)
        fetchFeedTweet()
    }
    
    // MARK: - Fetch
    
    private func fetchFeedTweet() {
        
        if UserDefaults.standard.object(forKey: ON_REFRESH) == nil {
            indicator.startAnimating()
        }
        tweets.removeAll()
        users.removeAll()
        tableView.reloadData()
        UserDefaults.standard.removeObject(forKey: ON_REFRESH)
        
        Follow.fetchFollows(User.currentUserId()) { (follow) in
            if follow.uid == "" {
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
                return
            }

            Tweet.fetchFeed(follow.uid) { (tweet) in
                if tweet.tweetId == "" {
                    self.indicator.stopAnimating()
                    return
                }
                self.fetchUser(tweet.uid) {
                    self.tweets.append(tweet)
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.refresh.endRefreshing()
                }
            }
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        User.fetchUser(uid) { (user) in
            if user.uid == "" { return }
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchFollows() {
        
        Follow.fetchFollows(User.currentUserId()) { (follow) in
            self.follows.insert(follow, at: 0)
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            if user.uid == "" {
                self.plusButton.isHidden = true
                self.plusBackView.isHidden = true
                return
            }
            self.user = user
            self.resetBadge(self.user)
            self.plusButton.isHidden = false
            self.plusBackView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func resetBadge(_ user: User) {
        
        let totalAppBadgeCount = user.appBadgeCount - user.communityBadgeCount
        
        updateUser(withValue: [COMMUNITY_BADGE_COUNT: 0, APP_BADGE_COUNT: totalAppBadgeCount])
        UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OtherVC" {
            let otherVC = segue.destination as! OtherViewController
            let userId = sender as! String
            otherVC.userId = userId
        }
        
        if segue.identifier == "TweetCommentVC" {
            let tweetCommentVC = segue.destination as! TweetCommentViewController
            let tweetId = sender as! String
            tweetCommentVC.tweetId = tweetId
        }
    }
    
    private func setup() {

        plusBackView.isHidden = true
        plusButton.isHidden = true
        tableView.separatorColor = .systemGray
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refresh.tintColor = UIColor.white
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8953298775"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

// MARK: - Table view

extension FeedTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        
        cell.feedVC = self
        cell.currentUser = self.user
        cell.tweet = tweets[indexPath.row]
        cell.user = users[indexPath.row]
        cell.configureCell(tweets[indexPath.row], users[indexPath.row])
        cell.configureLikeCount()
        
        return cell
    }
}

extension FeedTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "投稿はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "フォローしたユーザーの投稿が表示されます", attributes: attributes)
    }
}
