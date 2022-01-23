//
//  NewLoginViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import CryptoKit
import PKHUD

class NewLoginViewController: UIViewController {
    
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gmailLogin
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        UIBuild()

    }
    
    
    @IBAction func next(_ sender: Any) {
        
        if let _ = Auth.auth().currentUser?.uid {
            print("UserIDが存在しています。")
            
            //画面遷移
            let settingRoleViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingRoleViewController") as! SettingRoleViewController
            settingRoleViewController.modalPresentationStyle = .fullScreen
            self.present(settingRoleViewController, animated: true, completion: nil)
  
        } else {
           
            //ログイン処理をする
                let alert = UIAlertController(title: "サインイン処理がされていません！！", message: "下の項目から選択してください", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            sendRightFromLeft()
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: nil, completion: nil)
        sendLeftFromRight()
    }

    @IBAction func emailLogin(_ sender: Any) {
        performSegue(withIdentifier: "emailLoginVC", sender: nil)
        sendRightFromLeft()
    }
    
    @IBAction func gmailLogin(_ sender: Any) {
        
        if let _ = Auth.auth().currentUser?.uid {
            print("UserIDが存在しています。")
            
            let userID = Auth.auth().currentUser?.uid
            print("Current user id is \(String(describing: userID))")
            UserDefaults.standard.set(userID, forKey: "userID")
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let next: MainPageViewController = storyboard.instantiateInitialViewController() as! MainPageViewController
            self.present(next, animated: true, completion: nil)
  
        } else {
            print("UserIDが存在しません。")
            
            //gmail signIn
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
            
        }
    
    }
    
    //gmailログイン
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        
    // When user is signed in
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                //ログイン成功
                print("Login success")
                //画面遷移
                let settingRoleViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingRoleViewController") as! SettingRoleViewController
                settingRoleViewController.modalPresentationStyle = .fullScreen
                self.present(settingRoleViewController, animated: true, completion: nil)
        
            } else {
                
                //なぜnilになってしまうのかわからない。(credential)
                print(error?.localizedDescription as Any)
                return
            }
            
        })
    }
    
    
    func UIBuild() {
        
        //UIButton
        gmailButton.layer.shadowColor = UIColor.darkGray.cgColor
        gmailButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        gmailButton.layer.shadowOpacity = 0.3
        gmailButton.layer.shadowRadius = 10
        
        emailButton.layer.shadowColor = UIColor.black.cgColor
        emailButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        emailButton.layer.shadowOpacity = 0.3
        emailButton.layer.shadowRadius = 10
        
        //Label
        TitleLabel.text = "アカウントを作成しよう！！"
    }
    
    
}
