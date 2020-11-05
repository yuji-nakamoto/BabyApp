//
//  TutorialViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/04.
//

import UIKit
import Lottie
import AVFoundation

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    
    var videoPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 3
        skipButton.layer.cornerRadius = 3
        if UserDefaults.standard.object(forKey: END_TUTORIAL) != nil {
            skipButton.isHidden = true
            closeButton.isHidden = false
        } else {
            skipButton.isHidden = false
            closeButton.isHidden = true
        }
        setVideoPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        starAnimation()
    }
    
    private func setVideoPlayer() {
        
        guard let path = Bundle.main.path(forResource: "tutorial_video", ofType: "mp4") else {
            fatalError("Movie file can not find.")
        }
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        layer.frame = contentView.bounds
        contentView.layer.addSublayer(layer)
        
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        
        let interval : Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
        
        let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        
        videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            
            let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
            self.seekBar.value = value
        })
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    private func starAnimation() {
        
        let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rollingAnimation.fromValue = 0
        rollingAnimation.toValue = CGFloat.pi * 0.1
        rollingAnimation.duration = 0.1
        rollingAnimation.repeatDuration = CFTimeInterval.zero
        starButton.layer.add(rollingAnimation, forKey: "rollingImage")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rollingAnimation.fromValue = 0
            rollingAnimation.toValue = CGFloat.pi * -0.1
            rollingAnimation.duration = 0.1
            rollingAnimation.repeatDuration = CFTimeInterval.zero
            starButton.layer.add(rollingAnimation, forKey: "rollingImage")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rollingAnimation.fromValue = 0
                rollingAnimation.toValue = CGFloat.pi * 0.1
                rollingAnimation.duration = 0.1
                rollingAnimation.repeatDuration = CFTimeInterval.zero
                starButton.layer.add(rollingAnimation, forKey: "rollingImage")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rollingAnimation.fromValue = 0
                    rollingAnimation.toValue = CGFloat.pi * -0.1
                    rollingAnimation.duration = 0.1
                    rollingAnimation.repeatDuration = CFTimeInterval.zero
                    starButton.layer.add(rollingAnimation, forKey: "rollingImage")
                }
            }
        }
    }
    
    @IBAction func starButtonPressed(_ sender: Any) {
        
        let animationView = AnimationView(name: "star")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1
        
        view.addSubview(animationView)
        animationView.play()
        
        animationView.play { finished in
            if finished {
                animationView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func onSider(_ sender: UISlider) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(seekBar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: END_TUTORIAL)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
        self.present(tabVC, animated: true, completion: nil)
    }
}
