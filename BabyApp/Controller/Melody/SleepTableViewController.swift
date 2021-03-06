//
//  SleepTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import Firebase
import GoogleMobileAds

class SleepTableViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let soundFilePath1 = Bundle.main.path(forResource: "vinyl", ofType: "mp3")
    private let soundFilePath2 = Bundle.main.path(forResource: "hairdryer", ofType: "mp3")
    private let soundFilePath3 = Bundle.main.path(forResource: "washing_machine2", ofType: "mp3")
    private let soundFilePath4 = Bundle.main.path(forResource: "boiling1", ofType: "mp3")
    private let soundFilePath5 = Bundle.main.path(forResource: "shower", ofType: "mp3")
    private let soundFilePath6 = Bundle.main.path(forResource: "pouring_water2", ofType: "mp3")
    private let soundFilePath7 = Bundle.main.path(forResource: "cleaner_nearly", ofType: "mp3")
    private let soundFilePath8 = Bundle.main.path(forResource: "cleaner_far", ofType: "mp3")
    private let soundFilePath9 = Bundle.main.path(forResource: "white_noise1", ofType: "mp3")
    private let soundFilePath10 = Bundle.main.path(forResource: "300hz_noise", ofType: "mp3")
    private var user = User()
    
    lazy var sounds = [soundFilePath1, soundFilePath2, soundFilePath3, soundFilePath4, soundFilePath5, soundFilePath6, soundFilePath7, soundFilePath8, soundFilePath9, soundFilePath10]
    private var soundTexts = ["ビニール袋", "ドライヤー", "洗濯機", "煮物", "シャワー", "水を注ぐ", "掃除機1", "掃除機2", "砂嵐", "ノイズ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanner()
        checkBadge()
        messageSubscrive()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserDefaults.standard.object(forKey: SOUND_RELOAD1) != nil {
            tableView.reloadData()
            UserDefaults.standard.removeObject(forKey: SOUND_RELOAD1)
        }
    }
    
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    private func messageSubscrive() {
        
        guard User.currentUserId() != "" else { return }
        if UserDefaults.standard.object(forKey: PUSH_FOLLOW) != nil {
            Messaging.messaging().subscribe(toTopic: "follow\(User.currentUserId())")
        }
        if UserDefaults.standard.object(forKey: PUSH_POST) != nil {
            Messaging.messaging().subscribe(toTopic: "post\(User.currentUserId())")
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8618596167"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    private func checkBadge() {
        guard Auth.auth().currentUser != nil else { return }
        
        User.fetchUserAddSnapshotListener() { (user) in
            self.user = user

            if self.user.communityBadgeCount == 0 {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
                
            } else {
                self.tabBarController?.viewControllers?[2].tabBarItem?.badgeValue = String(self.user.communityBadgeCount)
            }
    
            if self.user.myPageBadgeCount == 0 {
                self.tabBarController?.viewControllers?[3].tabBarItem.badgeValue = nil
                
            } else {
                self.tabBarController?.viewControllers?[3].tabBarItem?.badgeValue = String(self.user.myPageBadgeCount)
            }
        }
    }
}

extension SleepTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SoundTableViewCell
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP1) != nil {
            if indexPath.row == 0 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 0 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP2) != nil {
            if indexPath.row == 1 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 1 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP3) != nil {
            if indexPath.row == 2 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 2 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP4) != nil {
            if indexPath.row == 3 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 3 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP5) != nil {
            if indexPath.row == 4 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 4 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP6) != nil {
            if indexPath.row == 5 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 5 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP7) != nil {
            if indexPath.row == 6 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 6 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP8) != nil {
            if indexPath.row == 7 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 7 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP9) != nil {
            if indexPath.row == 8 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 8 {
                cell.favoButton.alpha = 1
            }
        }
        
        if UserDefaults.standard.object(forKey: FAVO_SLEEP10) != nil {
            if indexPath.row == 9 {
                cell.favoButton.alpha = 0.5
            }
        } else {
            if indexPath.row == 9 {
                cell.favoButton.alpha = 1
            }
        }
        cell.sleepVC = self
        cell.setupSound1()
        cell.setupSound2()
        cell.sounds = sounds[indexPath.row]
        cell.soundText = soundTexts[indexPath.row]
        cell.configureCell(soundText: soundTexts[indexPath.row])
        return cell
    }
}
