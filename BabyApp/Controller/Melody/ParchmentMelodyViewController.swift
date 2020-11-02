//
//  ParchmentMelodyViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import Parchment

class ParchmentMelodyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sleepVC = storyboard.instantiateViewController(withIdentifier: "SleepVC")
        let natureVC = storyboard.instantiateViewController(withIdentifier: "NatureVC")
        let funVC = storyboard.instantiateViewController(withIdentifier: "FunVC")
        let animalVC = storyboard.instantiateViewController(withIdentifier: "AnimalVC")
        
        sleepVC.title = "泣き止む"
        natureVC.title = "自然"
        animalVC.title = "動物"
        funVC.title = "楽しい"
        
        let pagingVC = PagingViewController(viewControllers: [sleepVC, natureVC, animalVC, funVC])
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
        pagingVC.selectedTextColor = .white
        pagingVC.textColor = .white
        pagingVC.indicatorColor = .systemYellow
        pagingVC.menuItemSize = .fixed(width: 120, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        pagingVC.menuBackgroundColor = UIColor(named: O_NAVY2)!
        pagingVC.borderColor = UIColor(named: O_NAVY2)!
    }
}
