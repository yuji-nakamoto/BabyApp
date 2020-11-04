//
//  FollowTableViewCell.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/30.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    
    var user = User()
    var follow = Follow()
    var followCount = Follow()
    var followerCount = Follower()
    var blockListVC: BlockListTableViewController?
    var followVC: FollowTableViewController?
    var followerVC: FollowerTableViewController?
    
    func configureCell(_ user: User) {
        nameLabel.text = user.username
        selfIntroLabel.text = user.selfIntro
        guard user.profileImageUrl != nil else { return }
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
    }
    
    func configureBlockCell(_ user: User) {
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl), completed: nil)
        nameLabel.text = user.username
    }
    
    var block: Block? {
        didSet {
            timestampLabel.text = timestamp
        }
    }
    
    var timestamp: String {
        let date = block?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date!)
    }
    
    // MARK: - Actions
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: user.username, message: "ブロック解除しますか？", preferredStyle: .actionSheet)
        let release: UIAlertAction = UIAlertAction(title: "解除する", style: UIAlertAction.Style.default) { [self] (alert) in
            Block.deleteBlock(userId: block!.uid)
            blockListVC?.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(release)
        alert.addAction(cancel)
        blockListVC?.present(alert,animated: true,completion: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 60 / 2
        
        guard blockButton != nil else { return }
        blockButton.layer.cornerRadius = 24 / 2
    }
}
