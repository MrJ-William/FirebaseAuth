//
//  LoginTypeSelectViewController.swift
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

class LoginTypeSelectViewController: UIViewController {
    
    var provider:OAuthProvider?
    var currentNonce:String?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //twitterLogin
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        provider?.customParameters = ["lang":"ja"]
        
        //gmailLogin
        GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance.delegate = self
    
        titleLabel.text = "ログインしよう！！"
        
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
    
    
    
    @IBAction func emailLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    @IBAction func twitterLogin(_ sender: Any) {
        twitter()
    }
    
    @IBAction func gmailLogin(_ sender: Any) {
        //この位置が重要
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
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
            if (user?.user) != nil {
                
                //ユーザーIDの取得
                let userID = Auth.auth().currentUser?.uid
                print("Current user id is \(String(describing: userID))")
                UserDefaults.standard.set(userID, forKey: "userID")

                let storyboard: UIStoryboard = UIStoryboard(name: "Cirecle", bundle: nil)
                let next: MenuNavigationController = storyboard.instantiateInitialViewController() as! MenuNavigationController

                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true, completion: nil)

            } else {
                
                let alert = UIAlertController(title: "", message: "ユーザーIDまたはパスワードが間違っています。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("ユーザーIDまたはパスワードが間違っています")
                return
                
            }
        })
    }
    
}

