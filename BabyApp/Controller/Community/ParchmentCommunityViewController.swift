//
//  ParchmentCommunityViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import Parchment

class ParchmentCommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let communityVC = storyboard.instantiateViewController(withIdentifier: "CommunityVC")
        let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedVC")
        
        communityVC.title = "コミュニティ"
        feedVC.title = "フィード"
        
        let pagingVC = PagingViewController(viewControllers: [communityVC, feedVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 51)
        ])
        
        pagingVC.font = UIFont(name: "HiraMaruProN-W4", size: 12)!
        pagingVC.selectedFont = UIFont(name: "HiraMaruProN-W4", size: 14)!
        pagingVC.selectedTextColor = .black
        pagingVC.indicatorColor = UIColor.systemIndigo
        pagingVC.menuItemSize = .fixed(width: 130, height: 40)
        pagingVC.menuHorizontalAlignment = .center
    }
}
