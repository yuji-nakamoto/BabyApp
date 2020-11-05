//
//  StartViewController.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/11/02.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starIndicator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        starAnimation()
    }
    
    private func start() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            if UserDefaults.standard.object(forKey: END_TUTORIAL) != nil {
                toTabVC()
            } else {
                toTutorialVC()
            }
        }
    }
    
    private func starAnimation() {
        
        let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rollingAnimation.fromValue = 0
        rollingAnimation.toValue = CGFloat.pi * 7
        rollingAnimation.duration = 4
        rollingAnimation.repeatDuration = CFTimeInterval.zero
        starIndicator.layer.add(rollingAnimation, forKey: "rollingImage")
    }
    
    private func toTabVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
        self.present(tabVC, animated: true, completion: nil)
    }
    
    private func toTutorialVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialVC")
        self.present(tutorialVC, animated: true, completion: nil)
    }
}
