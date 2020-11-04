//
//  MyPageTableViewCell.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/29.
//

import UIKit
import Firebase

class MyPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followCountLbl: UILabel!
    @IBOutlet weak var followerCountLbl: UILabel!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var sIntroLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkFollowLbl: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    var user = User()
    var currentUser = User()
    var block = Block()
    var follow = Follow()
    var followCount = Follow()
    var followerCount = Follower()
    var otherVC: OtherViewController?
    
    func configureCell(_ user: User, _ followCount: Follow, _ followerCount: Follower) {
        
        nameLabel.text = user.username
        
        if user.profileImageUrl != "" {
            guard user.profileImageUrl != nil else { return }
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        } else {
            profileImageView.image = UIImage(named: "placeholder-image")
        }
        
        if user.selfIntro != "" {
            selfIntroLabel.text = user.selfIntro
            sIntroLblTopConstraint.constant = 15
        } else {
            sIntroLblTopConstraint.constant = 0
        }
        
        guard followerCount.followerCount != nil && followCount.followCount != nil else { return }
        followCountLbl.text = String(followCount.followCount)
        followerCountLbl.text = String(followerCount.followerCount)
    }
    
    func configureOtherCell(_ user: User, _ follow: Follow, _ followerCount: Follower, _ followCount: Follow, _ checkFollow: Follow) {
        
        nameLabel.text = user.username
        postLabel.text = "\(user.username ?? "")さんの投稿"
        guard user.profileImageUrl != nil else { return }
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        
        guard follow.uid != nil else { return }
        if follow.isFollow == true {
            followButton.setTitle("フォロー中", for: .normal)
        } else {
            followButton.setTitle("フォローする", for: .normal)
        }
        
        if checkFollow.isFollow == true {
            checkFollowLbl.isHidden = false
        } else {
            checkFollowLbl.isHidden = true
        }
        
        guard followerCount.followerCount != nil && followCount.followCount != nil else { return }
        followerCountLbl.text = String(followerCount.followerCount)
        followCountLbl.text = String(followCount.followCount)
    }
    
    // MARK: - Actions
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "\(user.username ?? "")さんを", preferredStyle: .actionSheet)
        let block: UIAlertAction = UIAlertAction(title: "ブロックする", style: UIAlertAction.Style.default) { [self] (alert) in
            otherVC?.performSegue(withIdentifier: "BlockVC", sender: self.user.uid)
        }
        let report: UIAlertAction = UIAlertAction(title: "通報する", style: UIAlertAction.Style.default) { [self] (alert) in
            otherVC?.performSegue(withIdentifier: "ReportVC", sender: self.user.uid)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        if self.block.isBlock == 1 {
            alert.addAction(report)
            alert.addAction(cancel)
        } else {
            alert.addAction(block)
            alert.addAction(report)
            alert.addAction(cancel)
        }
        otherVC?.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        
        if follow.isFollow == true {
            let alert = UIAlertController(title: user.username, message: "フォローを解除しますか？", preferredStyle: .actionSheet)
            let release = UIAlertAction(title: "解除する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                Follow.unFollow(userId: user.uid) {}
                Follower.unFollower(userId: user.uid) {}
                Follow.updateFollowCount(value: [FOLLOW_COUNT: followCount.followCount - 1]) {
                    Follower.updateFollowerCount(userId: user.uid,
                                                 value: [FOLLOWER_COUNT: followerCount.followerCount - 1]) {
                        otherVC?.viewWillAppear(true)
                    }
                }
                followButton.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    followButton.setTitle("フォローする", for: .normal)
                    followButton.isEnabled = true
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(release)
            alert.addAction(cancel)
            otherVC?.present(alert,animated: true,completion: nil)
            
        } else {
            let alert = UIAlertController(title: user.username, message: "フォローをしますか？", preferredStyle: .actionSheet)
            let release = UIAlertAction(title: "フォローする", style: UIAlertAction.Style.default) { [self] (alert) in
                
                incrementAppBadgeCount()
                Follow.toFollow(userId: user.uid, value: [UID: user.uid as Any, IS_FOLLOW: true]) {}
                Follower.toFollower(userId: user.uid, value: [UID: User.currentUserId(), IS_FOLLOWER: true]) {}
                Follow.updateFollowCount(value: [FOLLOW_COUNT: followCount.followCount + 1]) {
                    Follower.updateFollowerCount(userId: user.uid, value: [FOLLOWER_COUNT: followerCount.followerCount + 1]) {
                        otherVC?.viewWillAppear(true)
                    }
                }
                followButton.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    followButton.setTitle("フォロー中", for: .normal)
                    followButton.isEnabled = true
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(release)
            alert.addAction(cancel)
            otherVC?.present(alert,animated: true,completion: nil)
        }
    }
    
    private func incrementAppBadgeCount() {
        
        sendRequestNotification(userId: user.uid,
                                 message: "\(self.currentUser.username!)さんがフォローしました",
                                 badge: self.user.appBadgeCount + 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selfIntroLabel.text = ""
        followCountLbl.text = "0"
        followerCountLbl.text = "0"
        profileImageView.layer.cornerRadius = 80 / 2
        
        guard followButton != nil else { return }
        followButton.setTitle("", for: .normal)
        followButton.layer.cornerRadius = 30 / 2
        checkFollowLbl.isHidden = true
        checkFollowLbl.layer.borderColor = UIColor.systemGray.cgColor
        checkFollowLbl.layer.borderWidth = 1
        checkFollowLbl.layer.cornerRadius = 3
    }
}
