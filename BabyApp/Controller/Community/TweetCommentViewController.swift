//
//  TweetCommentViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import Firebase
import GoogleMobileAds

class TweetCommentViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var tweet = Tweet()
    private var tweet2 = Tweet()
    private var tweetComments = [Tweet]()
    private var tweetComment = Tweet()
    private var user = User()
    private var currentUser = User()
    private var users = [User]()
    private let refresh = UIRefreshControl()
    var tweetId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setup()
        fetchTweet()
        fetchCurrentUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func commentButtonPressd(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        sendButton.isEnabled = false
        let date: Double = Date().timeIntervalSince1970
        let commentId = UUID().uuidString
        let dict = [UID: User.currentUserId(),
                    COMMENT: textField.text as Any,
                    DATE: date,
                    TIMESTAMP: Timestamp(date: Date()),
                    TWEETID: tweetId,
                    COMMENTID: commentId]
        Tweet.saveTweetComment(tweetId: tweetId, commentId: commentId, withValue: dict)
        Tweet.updateCommentCount(tweetId: tweetId,
                                 withValue: [COMMENTCOUNT: tweet2.commentCount + 1])
        
        textField.resignFirstResponder()
        textField.text = ""
        fetchCommentCount(tweet)
    }
    
    // MARK: - Fetch
    
    private func fetchUser(_ tweet: Tweet) {
        
        User.fetchUser(tweet.uid) { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchTweet() {
        
        indicator.startAnimating()
        Tweet.fetchTweet(tweetId: tweetId) { (tweet) in
            if tweet.tweetId == "" {
                self.indicator.stopAnimating()
                return
            }
            self.tweet = tweet
            self.fetchUser(self.tweet)
            self.fetchTweetComment(self.tweet)
            self.fetchCommentCount(self.tweet)
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    private func fetchTweetComment(_ tweet: Tweet) {
      
        Tweet.fetchTweetComments(tweetId: tweetId) { (tweet) in
            self.fetchCommentCount(self.tweet)
            self.tweetComments.removeAll()
            self.users.removeAll()
            self.tableView.reloadData()
            
            if tweet.uid == "" {
                self.tableView.reloadData()
                return
            }
            self.fetchUser(tweet.uid) {
                self.tweetComment = tweet
                self.tweetComments.append(tweet)
                self.tableView.reloadData()
            }
        }
    }

    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchCommentCount(_ tweet: Tweet) {
        
        Tweet.fetchTweetCommentCount(tweetId: tweetId) { (tweet2) in
            self.tweet2 = tweet2
            self.tableView.reloadData()
        }
    }
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
        }
    }
    
    // MARK: - Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OtherVC" {
            let otherVC = segue.destination as! OtherViewController
            let userId = sender as! String
            otherVC.userId = userId
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
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8953298775"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setup() {
        navigationItem.title = "コメント"
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!, .foregroundColor: UIColor.white]
        sendButton.alpha = 0.5
        sendButton.isEnabled = false
        tableView.separatorColor = .systemGray2
        tableView.tableFooterView = UIView()
        sendButton.layer.cornerRadius = 10
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConstraint.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConstraint.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
            } else {
                viewBottomConstraint.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldDidChange() {
        
        let commentNum = 50 - textField.text!.count
        if commentNum < 0 {
            countLabel.text = "×"
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
        } else {
            countLabel.text = String(commentNum)
            if textField.text == "" {
                sendButton.isEnabled = false
                sendButton.alpha = 0.5
            } else {
                sendButton.isEnabled = true
                sendButton.alpha = 1
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - Table view

extension TweetCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + tweetComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TweetTableViewCell
            
            cell.user = self.user
            cell.tweetCommentVC = self
            cell.tweet = self.tweet
            cell.configureLikeCount()
            cell.configureCell(self.tweet, self.user)
            return cell
        }
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! TweetCommentTableViewCell
        
        cell2.tweetCommentVC = self
        cell2.tweet2 = tweet2
        cell2.tweet = tweetComments[indexPath.row - 1]
        cell2.configureCell(tweetComments[indexPath.row - 1], users[indexPath.row - 1], self.tweet)
        return cell2
    }
}
