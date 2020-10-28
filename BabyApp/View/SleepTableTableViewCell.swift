//
//  SleepTableTableViewCell.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import AVFoundation
import JGProgressHUD

class SleepTableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sleepNameLbl: UILabel!
    @IBOutlet weak var favoButton: UIButton!
    @IBOutlet weak var pauseImageView: UIImageView!
    @IBOutlet weak var pauseImageButton: UIView!
    @IBOutlet weak var releaseButton: UIButton!
    
    var soundText: String?
    var sounds: String?
    var sleepVC: SleepTableViewController?
    var favoVC: FavoriteTableViewController?
    private var player1 = AVAudioPlayer()
    private var player2 = AVAudioPlayer()
    private let soundFilePath = Bundle.main.path(forResource: "wadding_up1", ofType: "mp3")
    private var hud = JGProgressHUD(style: .dark)
    
    func configureCell(soundText: String) {
        sleepNameLbl.text = soundText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSleepLbl))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapPauseImageView))
        pauseImageButton.addGestureRecognizer(tap2)
        sleepNameLbl.addGestureRecognizer(tap)
        sleepNameLbl.isUserInteractionEnabled = true
        sleepNameLbl.layer.cornerRadius = 50 / 2
        sleepNameLbl.layer.borderWidth = 1
        sleepNameLbl.layer.borderColor = UIColor.systemIndigo.cgColor
        
        pauseImageView.alpha = 0
        pauseImageButton.alpha = 0
    }
    
    // MARK: - Helpers
    
    func setupSound() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            do {
                try player1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sounds!))
                player1.prepareToPlay()
            } catch  {
                print("Error sound", error.localizedDescription)
            }
        }
    }
    
    func setupReleseSound() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            do {
                try player2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath!))
                player2.prepareToPlay()
            } catch  {
                print("Error sound", error.localizedDescription)
            }
        }
    }
    
    private func setupHudSuccess() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (sleepVC?.view)!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    private func setupHudSuccess2() {
        hud.textLabel.text = "解除しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (favoVC?.view)!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    // MARK: - Actions
    
    @objc func tapSleepLbl() {
        
        player1.play()
        player1.numberOfLoops = -1
        if favoButton != nil {
            favoButton.isHidden = true
        }
        if releaseButton != nil {
            releaseButton.alpha = 0
        }
        sleepNameLbl.alpha = 0
        sleepNameLbl.clipsToBounds = true
        UIView.animate(withDuration: 0.3) { [self] in
            sleepNameLbl.alpha = 1
            pauseImageView.alpha = 1
            pauseImageButton.alpha = 1
            sleepNameLbl.text = ""
            sleepNameLbl.backgroundColor = .systemGray4
            sleepNameLbl.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    @objc func tapPauseImageView() {
        
        player1.stop()
        pauseImageView.alpha = 0
        pauseImageButton.alpha = 0
        sleepNameLbl.alpha = 0
        UIView.animate(withDuration: 0.3) { [self] in
            sleepNameLbl.alpha = 1
            if favoButton != nil {
                favoButton.isHidden = false
            }
            if releaseButton != nil {
                releaseButton.alpha = 1
            }
            sleepNameLbl.text = soundText
            sleepNameLbl.backgroundColor = .white
            sleepNameLbl.layer.borderColor = UIColor.systemIndigo.cgColor
        }
    }
    
    @IBAction func favoButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: soundText, message: "お気に入り登録しますか？", preferredStyle: .alert)
        let alert2 = UIAlertController(title: soundText, message: "お気に入り登録済みです", preferredStyle: .alert)
        let veritification = UIAlertAction(title: "確認", style: .cancel)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let registration = UIAlertAction(title: "登録する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            if sleepNameLbl.text == "ビニール袋" {
                setupHudSuccess()
                UserDefaults.standard.set("ビニール袋", forKey: FAVO_TEXT1)
            }
            
            if sleepNameLbl.text == "ドライヤー" {
                setupHudSuccess()
                UserDefaults.standard.set("ドライヤー", forKey: FAVO_TEXT2)
            }
            
            if sleepNameLbl.text == "洗濯機" {
                setupHudSuccess()
                UserDefaults.standard.set("洗濯機", forKey: FAVO_TEXT3)
            }
            
            if sleepNameLbl.text == "煮物" {
                setupHudSuccess()
                UserDefaults.standard.set("煮物", forKey: FAVO_TEXT4)
            }
            
            if sleepNameLbl.text == "シャワー" {
                setupHudSuccess()
                UserDefaults.standard.set("シャワー", forKey: FAVO_TEXT5)
            }
            
            if sleepNameLbl.text == "水を注ぐ" {
                setupHudSuccess()
                UserDefaults.standard.set("水を注ぐ", forKey: FAVO_TEXT6)
            }
            
            if sleepNameLbl.text == "掃除機1" {
                setupHudSuccess()
                UserDefaults.standard.set("掃除機1", forKey: FAVO_TEXT7)
            }
            
            if sleepNameLbl.text == "掃除機2" {
                setupHudSuccess()
                UserDefaults.standard.set("掃除機2", forKey: FAVO_TEXT8)
            }
            sleepVC?.viewWillAppear(true)
        }
        
        if favoButton.alpha == 0.5 {
            alert2.addAction(veritification)
            sleepVC?.present(alert2,animated: true,completion: nil)
        } else {
            alert.addAction(registration)
            alert.addAction(cancel)
            sleepVC?.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: soundText, message: "お気に入りを解除しますか？", preferredStyle: .alert)
        let release = UIAlertAction(title: "解除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            player2.play()
            if sleepNameLbl.text == "ビニール袋" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT1)
            }
            
            if sleepNameLbl.text == "ドライヤー" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT2)
            }
            
            if sleepNameLbl.text == "洗濯機" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT3)
            }
            
            if sleepNameLbl.text == "煮物" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT4)
            }
            
            if sleepNameLbl.text == "シャワー" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT5)
            }
            
            if sleepNameLbl.text == "水を注ぐ" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT6)
            }
            
            if sleepNameLbl.text == "掃除機1" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT7)
            }
            
            if sleepNameLbl.text == "掃除機2" {
                UserDefaults.standard.removeObject(forKey: FAVO_TEXT8)
            }
            
            setupHudSuccess2()
            favoVC?.viewWillAppear(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                player2.stop()
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(release)
        alert.addAction(cancel)
        favoVC?.present(alert,animated: true,completion: nil)
    }
}
