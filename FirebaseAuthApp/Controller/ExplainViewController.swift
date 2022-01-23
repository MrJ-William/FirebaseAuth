//
//  NewLoginViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.
//

import UIKit
import Lottie

class ExplainViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var onboardArray = ["2","3","4"]
    var onboardStringArray = ["あなたに合ったサークルを見つけよう！","ミスユニでいろんなコミュニティと\n繋がろう!","ミスユニは楽しいキャンパスライフを\n応援しています。"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        UIBuild()
        AnimationSetting()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func skipped(_ sender: Any) {
        
        performSegue(withIdentifier: "selectLoginVC", sender: nil)
        sendRightFromLeft()
        
    }
    
    func UIBuild(){
            
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.height)
        
        for i in 0...2 {
            
            // iPhoneの機種判定
            switch (UIScreen.main.nativeBounds.height) {

            case 1334:
                // iPhone 6
                // iPhone 6s
                // iPhone 7
                // iPhone 8
                let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height / 5.4, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                onboardLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                onboardLabel.textAlignment = .center
                onboardLabel.textColor = .white
                onboardLabel.numberOfLines = 2
                onboardLabel.text = onboardStringArray[i]
                scrollView.addSubview(onboardLabel)

                
                break
            case 2208:
                // iPhone 6 Plus
                // iPhone 6s Plus
                // iPhone 7 Plus
                // iPhone 8 Plus
                
                let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height / 5.4, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                onboardLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                onboardLabel.textAlignment = .center
                onboardLabel.textColor = .white
                onboardLabel.numberOfLines = 2
                onboardLabel.text = onboardStringArray[i]
                scrollView.addSubview(onboardLabel)
                
                break
            case 2436:
                
                //iPhone X
                let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height / 4.4, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                onboardLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                onboardLabel.textAlignment = .center
                onboardLabel.textColor = .white
                onboardLabel.numberOfLines = 2
                onboardLabel.text = onboardStringArray[i]
                scrollView.addSubview(onboardLabel)

                break
            default:
                
                let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height / 3.4, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                onboardLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                onboardLabel.textAlignment = .center
                onboardLabel.textColor = .white
                onboardLabel.numberOfLines = 2
                onboardLabel.text = onboardStringArray[i]
                scrollView.addSubview(onboardLabel)
                
                break
                
            }
        }
        
    }
    
    func AnimationSetting() {
        for i in 0...2 {
            
            let animationView = AnimationView()
            let animation = Animation.named(onboardArray[i])
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.animationSpeed = 0.8
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
            
         }
    }

}
