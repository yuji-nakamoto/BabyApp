//
//  TweetTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class TweetTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var hintVIew: UIView!
    @IBOutlet weak var plusBackView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var tweets = [Tweet]()
    private var tweet = Tweet()
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupBanner()
        testBanner()
        
        setup()
        fetchUser()
        if UserDefaults.standard.object(forKey: REFRESH) == nil {
            fetchTweet()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchTweet()
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: ON_HUD) != nil {
            showHintView()
        }
    }
    
    // MARK: - Actions
    
    @objc func refreshTableView(){
        UserDefaults.standard.set(true, forKey: ON_REFRESH)
        fetchTweet()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        self.present(registerVC, animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchTweet() {
        
        if UserDefaults.standard.object(forKey: ON_REFRESH) == nil {
            indicator.startAnimating()
        }
        tweets.removeAll()
        users.removeAll()
        tableView.reloadData()
        UserDefaults.standard.removeObject(forKey: ON_REFRESH)
        
        Tweet.fetchTweets { (tweet) in
            if tweet.uid == "" {
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
                self.tableView.reloadData()
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
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        User.fetchUser(uid) { (user) in
            if user.uid == "" { return }
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            if user.uid == "" {
                self.plusButton.isHidden = true
                self.plusBackView.isHidden = true
                self.registerButton.isHidden = false
                return
            }
            self.user = user
            self.plusButton.isHidden = false
            self.plusBackView.isHidden = false
            self.registerButton.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func showHintView() {
        
        UIView.animate(withDuration: 0.5) { [self] in
            hintVIew.alpha = 0.9
        } completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.5) { [self] in
                    hintVIew.alpha = 0
                    UserDefaults.standard.removeObject(forKey: ON_HUD)
                }
            }
        }
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
        
        plusButton.isHidden = true
        plusBackView.isHidden = true
        registerButton.isHidden = true
        registerButton.layer.cornerRadius = 44 / 2
        hintVIew.layer.cornerRadius = 10
        hintVIew.alpha = 0
        tableView.separatorColor = .systemGray
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refresh.tintColor = UIColor.white
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
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

extension TweetTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        
        cell.tweetVC = self
        cell.currentUser = self.user
        cell.tweet = tweets[indexPath.row]
        cell.user = users[indexPath.row]
        cell.configureCell(tweets[indexPath.row], users[indexPath.row])
        cell.configureLikeCount()
        
        return cell
    }
}

extension TweetTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "投稿はありません", attributes: attributes)
    }
}
