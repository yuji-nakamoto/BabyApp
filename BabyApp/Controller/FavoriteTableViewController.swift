//
//  FavoriteTableViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import GoogleMobileAds

class FavoriteTableViewController: UIViewController {
    
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
    private var sounds = [String]()
    private var soundTexts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        navigationItem.title = "お気に入り"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSounds()
    }
    
    private func setSounds() {
        
        sounds.removeAll()
        soundTexts.removeAll()
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT1) != nil {
            sounds.append(soundFilePath1!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT1) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT2) != nil {
            sounds.append(soundFilePath2!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT2) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT3) != nil {
            sounds.append(soundFilePath3!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT3) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT4) != nil {
            sounds.append(soundFilePath4!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT4) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT5) != nil {
            sounds.append(soundFilePath5!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT5) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT6) != nil {
            sounds.append(soundFilePath6!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT6) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT7) != nil {
            sounds.append(soundFilePath7!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT7) as! String)
        }
        
        if UserDefaults.standard.object(forKey: FAVO_TEXT8) != nil {
            sounds.append(soundFilePath8!)
            soundTexts.append(UserDefaults.standard.object(forKey: FAVO_TEXT8) as! String)
        }
        tableView.reloadData()
    }
}

extension FavoriteTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SleepTableTableViewCell
        
        cell.favoVC = self
        cell.sounds = sounds[indexPath.row]
        cell.soundText = soundTexts[indexPath.row]
        cell.configureCell(soundText: soundTexts[indexPath.row])
        cell.setupSound()
        cell.setupReleseSound()
        return cell
    }
}

