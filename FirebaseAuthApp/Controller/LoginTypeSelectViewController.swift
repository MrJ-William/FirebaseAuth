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
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    @IBAction func emailLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
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

