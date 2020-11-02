//
//  TweetTableViewCell.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import Firebase
import SDWebImage

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    
    var tweetVC: TweetTableViewController?
    var myPageVC: MyPageViewController?
    var otherVC: OtherViewController?
    var tweetCommentVC: TweetCommentViewController?
    var feedVC: FeedTableViewController?
    var user = User()
    var currentUser = User()
    var tweet = Tweet() {
        didSet {
            if timestampLabel != nil {
                timestampLabel.text = timestamp
            }
        }
    }
    
    var timestamp: String {
        guard tweet.timestamp != nil else { return "" }
        let date = tweet.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Cell
    
    func configureCell(_ tweet: Tweet, _ user: User) {
        
        nameLabel.text = user.username
        tweetLabel.text = tweet.text

        if user.profileImageUrl != nil {
            profileImageVIew.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        }
        
        if tweet.contentsImageUrl == nil { return }
        contentsImageView.sd_setImage(with: URL(string: tweet.contentsImageUrl), completed: nil)

        if tweet.contentsImageUrl == "" {
            heightConstraint.constant = 0
            bottomConstraint.constant = 0
        } else {
            heightConstraint.constant = 300
            bottomConstraint.constant = 15
        }
                
        if  timeLabel != nil {
            let date = Date(timeIntervalSince1970: tweet.date)
            let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            timeLabel.text = dateString
        }
        
        if tweet.commentCount == nil || tweet.commentCount == 0 {
            commentCountLabel.text = ""
        } else {
            commentCountLabel.text = String(tweet.commentCount)
        }
        
        if tweet.likeCount == nil || tweet.likeCount == 0 {
            likeCountLabel.text = ""
        } else {
            likeCountLabel.text = String(tweet.likeCount)
        }
        
        if reportButton != nil {
            if tweet.uid == User.currentUserId() {
                reportButton.isHidden = true
            } else {
                reportButton.isHidden = false
            }
        }
        
        guard deleteButton != nil else { return }
        if tweet.uid == User.currentUserId() {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    func configureLikeCount() {
        
        guard tweet.tweetId != nil else { return }
        Tweet.checkIsLikeTweet(tweetId: tweet.tweetId) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.tintColor = UIColor.systemGray
            } else {
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.tintColor = UIColor.systemPink
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
            UserDefaults.standard.set(true, forKey: ON_HUD)
            tweetVC?.viewDidAppear(true)
            return
        }
        
        Tweet.checkIsLikeTweet(tweetId: tweet.tweetId) { [self] (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.tintColor = UIColor.systemPink
                self.likeCountLabel.text = String(self.tweet.likeCount + 1)
                Tweet.updateIsLikeTweet(tweetId: self.tweet.tweetId,
                                        value1: [LIKECOUNT: self.tweet.likeCount + 1],
                                        value2: [User.currentUserId(): true])
                Tweet.updateOtherLikeCount(userId: user.uid, tweetId: tweet.tweetId,
                                           value: [LIKECOUNT: tweet.likeCount + 1])
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "投稿を削除しますか？", preferredStyle: .alert)
        let delete: UIAlertAction = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in
            UserDefaults.standard.set(true, forKey: REFRESH)
            Tweet.deleteTweet(tweetId: self.tweet.tweetId)
            self.tweetVC?.viewWillAppear(true)
            self.myPageVC?.viewWillAppear(true)
            self.otherVC?.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        tweetVC?.present(alert,animated: true,completion: nil)
        myPageVC?.present(alert,animated: true,completion: nil)
        otherVC?.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {

        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
            UserDefaults.standard.set(true, forKey: ON_HUD)
            tweetVC?.viewDidAppear(true)
            return
        }
        
        if let uid = tweet.tweetId {
            tweetVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            myPageVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            feedVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            otherVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "\(user.username ?? "")さんを", preferredStyle: .actionSheet)
        let block = UIAlertAction(title: "ブロックする", style: UIAlertAction.Style.default) { [self] (alert) in
            tweetCommentVC?.performSegue(withIdentifier: "BlockVC", sender: self.user.uid)
        }
        let report = UIAlertAction(title: "通報する", style: UIAlertAction.Style.default) { [self] (alert) in
            tweetCommentVC?.performSegue(withIdentifier: "ReportVC", sender: self.user.uid)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(cancel)
        tweetCommentVC?.present(alert,animated: true,completion: nil)
    }
    
    @objc func tapProfileImageView() {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
            UserDefaults.standard.set(true, forKey: ON_HUD)
            tweetVC?.viewDidAppear(true)
            return
        }
        
        if let uid = user.uid {
            if uid == User.currentUserId() { return }
            tweetVC?.performSegue(withIdentifier: "OtherVC", sender: uid)
            tweetCommentVC?.performSegue(withIdentifier: "OtherVC", sender: uid)
            feedVC?.performSegue(withIdentifier: "OtherVC", sender: uid)
        }
    }
    
    @objc func tapContentsImageView() {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil {
            UserDefaults.standard.set(true, forKey: ON_HUD)
            tweetVC?.viewDidAppear(true)
            return
        }
        
        if let uid = tweet.tweetId {
            tweetVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            myPageVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            feedVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            otherVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
    }
    
    @objc func tapTweetLabel() {
        
        if UserDefaults.standard.object(forKey: IS_LOGIN) == nil { return }
        if let uid = tweet.tweetId {
            tweetVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            myPageVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            feedVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
        if let uid = tweet.tweetId {
            otherVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
    }
    
    // MARK: - Helper
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapContentsImageView))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapTweetLabel))
        profileImageVIew.addGestureRecognizer(tap1)
        contentsImageView.addGestureRecognizer(tap2)
        tweetLabel.addGestureRecognizer(tap3)

        if contentsImageView != nil {
            contentsImageView.layer.cornerRadius = 15
        }
        profileImageVIew.layer.cornerRadius = 50 / 2
        
        if timeLabel != nil {
            timeLabel.text = ""
        } else {
            timestampLabel.text = ""
        }
        
        if reportButton != nil {
            reportButton.isHidden = true
        }
        tweetLabel.text = ""
        nameLabel.text = ""
        likeCountLabel.text = ""
    }
}
