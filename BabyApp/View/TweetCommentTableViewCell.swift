//
//  TweetCommentTableViewCell.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import Firebase

class TweetCommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var tweet = Tweet()
    var tweet2 = Tweet()
    var tweetCommentVC: TweetCommentViewController?
    
    // MARK: - Cell
    
    func configureCell(_ tweet: Tweet, _ user: User, _ mainTweet: Tweet) {
        
        let date = Date(timeIntervalSince1970: tweet.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        
        nameLabel.text = user.username
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        commentLabel.text = tweet.comment
        timeLabel.text = dateString
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "削除", message: "コメントを削除しますか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in

            Tweet.deleteComment(tweetId: self.tweetCommentVC!.tweetId, commentId: self.tweet.commentId)
            Tweet.updateCommentCount(tweetId: self.tweetCommentVC!.tweetId,
                                     withValue: [COMMENTCOUNT: self.tweet2.commentCount - 1])
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        tweetCommentVC?.present(alert,animated: true,completion: nil)
    }
    
    @objc func tapProfileImageView() {
        
        if let uid = tweet.uid {
            if uid == User.currentUserId() { return }
            tweetCommentVC?.performSegue(withIdentifier: "OtherVC", sender: uid)
        }
    }
    
    // MARK: - Helpers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView))
        profileImageView.addGestureRecognizer(tap1)
        profileImageView.layer.cornerRadius = 40 / 2
        nameLabel.text = ""
        timeLabel.text = ""
        commentLabel.text = ""
    }
}
