//
//  SoundTableTableViewCell.swift.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import AVFoundation
import JGProgressHUD

class SoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var soundNameLbl: UILabel!
    @IBOutlet weak var favoButton: UIButton!
    @IBOutlet weak var pauseImageView: UIImageView!
    @IBOutlet weak var pauseImageButton: UIView!
    @IBOutlet weak var releaseButton: UIButton!
    
    var soundText: String?
    var sounds: String?
    var sleepVC: SleepTableViewController?
    var funVC: FunTableViewController?
    var favoVC: FavoriteTableViewController?
    var animalVC: AnimalTableViewController?
    private var player1 = AVAudioPlayer()
    private var player2 = AVAudioPlayer()
    private let soundFilePath = Bundle.main.path(forResource: "wadding_up1", ofType: "mp3")
    private var hud = JGProgressHUD(style: .dark)
    
    func configureCell(soundText: String) {
        soundNameLbl.text = soundText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSleepLbl))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapPauseImageView))
        pauseImageButton.addGestureRecognizer(tap2)
        soundNameLbl.addGestureRecognizer(tap)
        soundNameLbl.isUserInteractionEnabled = true
        soundNameLbl.layer.cornerRadius = 50 / 2
        soundNameLbl.layer.borderWidth = 1
        soundNameLbl.layer.borderColor = UIColor.systemIndigo.cgColor
        
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
    
    private func setupHudSuccess1() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (sleepVC?.view)!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    private func setupHudSuccess3() {
        hud.textLabel.text = "登録しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (funVC?.view)!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    private func setupHudSuccess2() {
        hud.textLabel.text = "解除しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (favoVC?.view)!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    private func setupHudSuccess4() {
        hud.textLabel.text = "解除しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: (animalVC?.view)!)
        hud.dismiss(afterDelay: 1.5)
    }
    
    // MARK: - Actions
    
    @objc func tapSleepLbl() {
        
        player1.play()
        if UserDefaults.standard.object(forKey: ON_FUN_VC) != nil {
            player1.numberOfLoops = 0
        } else {
            player1.numberOfLoops = -1
        }
        
        if favoButton != nil {
            favoButton.isHidden = true
        }
        if releaseButton != nil {
            releaseButton.alpha = 0
        }
        soundNameLbl.alpha = 0
        soundNameLbl.clipsToBounds = true
        UIView.animate(withDuration: 0.3) { [self] in
            soundNameLbl.alpha = 1
            pauseImageView.alpha = 1
            pauseImageButton.alpha = 1
            soundNameLbl.text = ""
            soundNameLbl.backgroundColor = .systemGray4
            soundNameLbl.layer.borderColor = UIColor.systemGray4.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if !player1.isPlaying {
                    pauseImageView.alpha = 0
                    pauseImageButton.alpha = 0
                    soundNameLbl.text = soundText
                    soundNameLbl.backgroundColor = .white
                    soundNameLbl.layer.borderColor = UIColor.systemIndigo.cgColor
                    guard favoButton != nil else {
                        releaseButton.alpha = 1
                        return
                    }
                    favoButton.isHidden = false
                }
            }
        }
    }
    
    @objc func tapPauseImageView() {
        
        player1.stop()
        pauseImageView.alpha = 0
        pauseImageButton.alpha = 0
        soundNameLbl.alpha = 0
        UIView.animate(withDuration: 0.3) { [self] in
            soundNameLbl.alpha = 1
            if favoButton != nil {
                favoButton.isHidden = false
            }
            if releaseButton != nil {
                releaseButton.alpha = 1
            }
            soundNameLbl.text = soundText
            soundNameLbl.backgroundColor = .white
            soundNameLbl.layer.borderColor = UIColor.systemIndigo.cgColor
        }
    }
    
    @IBAction func favoButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: soundText, message: "お気に入り登録しますか？", preferredStyle: .alert)
        let alert2 = UIAlertController(title: soundText, message: "お気に入り登録済みです", preferredStyle: .alert)
        let veritification = UIAlertAction(title: "確認", style: .cancel)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let registration = UIAlertAction(title: "登録する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            if soundNameLbl.text == "ビニール袋" {
                setupHudSuccess1()
                UserDefaults.standard.set("ビニール袋", forKey: FAVO_SLEEP1)
            }
            
            if soundNameLbl.text == "ドライヤー" {
                setupHudSuccess1()
                UserDefaults.standard.set("ドライヤー", forKey: FAVO_SLEEP2)
            }
            
            if soundNameLbl.text == "洗濯機" {
                setupHudSuccess1()
                UserDefaults.standard.set("洗濯機", forKey: FAVO_SLEEP3)
            }
            
            if soundNameLbl.text == "煮物" {
                setupHudSuccess1()
                UserDefaults.standard.set("煮物", forKey: FAVO_SLEEP4)
            }
            
            if soundNameLbl.text == "シャワー" {
                setupHudSuccess1()
                UserDefaults.standard.set("シャワー", forKey: FAVO_SLEEP5)
            }
            
            if soundNameLbl.text == "水を注ぐ" {
                setupHudSuccess1()
                UserDefaults.standard.set("水を注ぐ", forKey: FAVO_SLEEP6)
            }
            
            if soundNameLbl.text == "掃除機1" {
                setupHudSuccess1()
                UserDefaults.standard.set("掃除機1", forKey: FAVO_SLEEP7)
            }
            
            if soundNameLbl.text == "掃除機2" {
                setupHudSuccess1()
                UserDefaults.standard.set("掃除機2", forKey: FAVO_SLEEP8)
            }
            
            if soundNameLbl.text == "砂嵐" {
                setupHudSuccess1()
                UserDefaults.standard.set("砂嵐", forKey: FAVO_SLEEP9)
            }
            
            if soundNameLbl.text == "ノイズ" {
                setupHudSuccess1()
                UserDefaults.standard.set("ノイズ", forKey: FAVO_SLEEP10)
            }
            
            if soundNameLbl.text == "魔法" {
                setupHudSuccess3()
                UserDefaults.standard.set("魔法", forKey: FAVO_FUN1)
            }
            
            if soundNameLbl.text == "ジャンプ" {
                setupHudSuccess3()
                UserDefaults.standard.set("ジャンプ", forKey: FAVO_FUN2)
            }
            
            if soundNameLbl.text == "ポカッ" {
                setupHudSuccess3()
                UserDefaults.standard.set("ポカッ", forKey: FAVO_FUN3)
            }
            
            if soundNameLbl.text == "プンッ" {
                setupHudSuccess3()
                UserDefaults.standard.set("プンッ", forKey: FAVO_FUN4)
            }
            
            if soundNameLbl.text == "ブゥーン" {
                setupHudSuccess3()
                UserDefaults.standard.set("ブゥーン", forKey: FAVO_FUN5)
            }
            
            if soundNameLbl.text == "ポォーン" {
                setupHudSuccess3()
                UserDefaults.standard.set("ポォーン", forKey: FAVO_FUN6)
            }
            
            if soundNameLbl.text == "ワープ" {
                setupHudSuccess3()
                UserDefaults.standard.set("ワープ", forKey: FAVO_FUN7)
            }
            
            if soundNameLbl.text == "キラキラ" {
                setupHudSuccess3()
                UserDefaults.standard.set("キラキラ", forKey: FAVO_FUN7)
            }
            
            if soundNameLbl.text == "カーニバル" {
                setupHudSuccess3()
                UserDefaults.standard.set("カーニバル", forKey: FAVO_FUN8)
            }
            
            if soundNameLbl.text == "いぬ" {
                setupHudSuccess4()
                UserDefaults.standard.set("いぬ", forKey: FAVO_ANIMAL1)
            }
            
            if soundNameLbl.text == "ねこ" {
                setupHudSuccess4()
                UserDefaults.standard.set("ねこ", forKey: FAVO_ANIMAL2)
            }
            
            if soundNameLbl.text == "やぎ" {
                setupHudSuccess4()
                UserDefaults.standard.set("やぎ", forKey: FAVO_ANIMAL3)
            }
            
            if soundNameLbl.text == "ぞう" {
                setupHudSuccess4()
                UserDefaults.standard.set("ぞう", forKey: FAVO_ANIMAL4)
            }
            
            if soundNameLbl.text == "うし" {
                setupHudSuccess4()
                UserDefaults.standard.set("うし", forKey: FAVO_ANIMAL5)
            }
            
            if soundNameLbl.text == "からす" {
                setupHudSuccess4()
                UserDefaults.standard.set("からす", forKey: FAVO_ANIMAL6)
            }
            
            if soundNameLbl.text == "ひよこ" {
                setupHudSuccess4()
                UserDefaults.standard.set("ひよこ", forKey: FAVO_ANIMAL7)
            }
            
            if soundNameLbl.text == "にわとり" {
                setupHudSuccess4()
                UserDefaults.standard.set("にわとり", forKey: FAVO_ANIMAL8)
            }
            
            if soundNameLbl.text == "うぐいす" {
                setupHudSuccess4()
                UserDefaults.standard.set("うぐいす", forKey: FAVO_ANIMAL9)
            }
            
            sleepVC?.tableView.reloadData()
            funVC?.tableView.reloadData()
            animalVC?.tableView.reloadData()
        }
        
        if favoButton.alpha == 0.5 {
            alert2.addAction(veritification)
            sleepVC?.present(alert2,animated: true,completion: nil)
            funVC?.present(alert2,animated: true,completion: nil)
            animalVC?.present(alert2,animated: true,completion: nil)
        } else {
            alert.addAction(registration)
            alert.addAction(cancel)
            sleepVC?.present(alert,animated: true,completion: nil)
            funVC?.present(alert,animated: true,completion: nil)
            animalVC?.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: soundText, message: "お気に入りを解除しますか？", preferredStyle: .alert)
        let release = UIAlertAction(title: "解除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            player2.play()
            if soundNameLbl.text == "ビニール袋" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP1)
            }
            
            if soundNameLbl.text == "ドライヤー" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP2)
            }
            
            if soundNameLbl.text == "洗濯機" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP3)
            }
            
            if soundNameLbl.text == "煮物" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP4)
            }
            
            if soundNameLbl.text == "シャワー" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP5)
            }
            
            if soundNameLbl.text == "水を注ぐ" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP6)
            }
            
            if soundNameLbl.text == "掃除機1" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP7)
            }
            
            if soundNameLbl.text == "掃除機2" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP8)
            }
            
            if soundNameLbl.text == "砂嵐" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP9)
            }
            
            if soundNameLbl.text == "ノイズ" {
                UserDefaults.standard.removeObject(forKey: FAVO_SLEEP10)
            }
            
            if soundNameLbl.text == "魔法" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN1)
            }
            
            if soundNameLbl.text == "ジャンプ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN2)
            }
            
            if soundNameLbl.text == "ポカッ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN3)
            }
            
            if soundNameLbl.text == "プンッ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN4)
            }
            
            if soundNameLbl.text == "ブゥーン" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN5)
            }
            
            if soundNameLbl.text == "ポォーン" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN6)
            }
            
            if soundNameLbl.text == "ワープ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN7)
            }
            
            if soundNameLbl.text == "キラキラ" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN8)
            }
            
            if soundNameLbl.text == "カーニバル" {
                UserDefaults.standard.removeObject(forKey: FAVO_FUN9)
            }

            if soundNameLbl.text == "いぬ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL1)
            }
            
            if soundNameLbl.text == "ねこ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL2)
            }
            
            if soundNameLbl.text == "やぎ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL3)
            }
            
            if soundNameLbl.text == "ぞう" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL4)
            }
            
            if soundNameLbl.text == "うし" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL5)
            }
            
            if soundNameLbl.text == "からす" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL6)
            }
            
            if soundNameLbl.text == "ひよこ" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL7)
            }
            
            if soundNameLbl.text == "にわとり" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL8)
            }
            
            if soundNameLbl.text == "うぐいす" {
                UserDefaults.standard.removeObject(forKey: FAVO_ANIMAL9)
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
