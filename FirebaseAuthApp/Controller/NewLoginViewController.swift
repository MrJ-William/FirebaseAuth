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
    
    // Present the auth view controller and then implement the sign in callback
    var currentNonce:String?
    var provider:OAuthProvider?
    
    @IBOutlet weak var gmailButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //twitterLogin
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        provider?.customParameters = ["lang":"ja"]
        
        //gmailLogin
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //UIButton
        gmailButton.layer.shadowColor = UIColor.darkGray.cgColor
        gmailButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        gmailButton.layer.shadowOpacity = 0.3
        gmailButton.layer.shadowRadius = 10
        
        twitterButton.layer.shadowColor = UIColor.black.cgColor
        twitterButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        twitterButton.layer.shadowOpacity = 0.3
        twitterButton.layer.shadowRadius = 10
        
        emailButton.layer.shadowColor = UIColor.black.cgColor
        emailButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        emailButton.layer.shadowOpacity = 0.3
        emailButton.layer.shadowRadius = 10
        
        //Label
        TitleLabel.text = "アカウントを作成しよう！！"
        
        //appleログイン
        let authOption:UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOption) { (_, _) in
            
            print("プッシュ許可画面OK")
        }
        
        appleButton.cornerRadius = 16.5
        appleButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        appleButton.layer.shadowColor = UIColor.black.cgColor
        appleButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        appleButton.layer.shadowOpacity = 0.3
        appleButton.layer.shadowRadius = 10
    
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
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tap(){
        
        let nonce = randomNonceString()
        
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @IBAction func twitterLogin(_ sender: Any) {
        twitter()
        
        print(Auth.auth().currentUser?.uid as Any)
        
        if let _ = Auth.auth().currentUser?.uid {
            print("UserIDが存在しています。")
        } else {
            print("UserIDが存在しません。")
        }

        //ダメならアラートを出す。
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "emailLoginVC", sender: nil)
        
    }
    
    @IBAction func gmailLogin(_ sender: Any) {
        
        if let _ = Auth.auth().currentUser?.uid {
            print("UserIDが存在しています。")
            
            //画面遷移
            let settingRoleViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingRoleViewController") as! SettingRoleViewController
            settingRoleViewController.modalPresentationStyle = .fullScreen
            self.present(settingRoleViewController, animated: true, completion: nil)
  
        } else {
            print("UserIDが存在しません。")
            //この位置が重要
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
    
    
}
