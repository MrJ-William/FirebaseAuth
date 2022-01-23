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

class LoginTypeSelectViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "ログインしよう！！"
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        sendLeftFromRight()
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
        sendRightFromLeft()
    }
    
    @IBAction func gmailLogin(_ sender: Any) {
   
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                // ...
                let alert = UIAlertController(title: "", message: "ユーザーIDまたはパスワードが間違っています。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("ユーザーIDまたはパスワードが間違っています")
                
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            
            // When user is signed in
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if (user?.user) != nil {
                    
                    print(UserDefaults.standard.object(forKey: "userID") as Any)
                    
                    //ユーザーIDの取得
                    let userID = Auth.auth().currentUser?.uid
                    print("Current user id is \(String(describing: userID))")
                    UserDefaults.standard.set(userID, forKey: "userID")
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let next: MainPageViewController = storyboard.instantiateInitialViewController() as! MainPageViewController
                    self.present(next, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "", message: "ユーザーIDまたはパスワードが間違っています。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    print("ユーザーIDまたはパスワードが間違っています")
                    return
                    
                }
            })
            // ...
        }
    }
    
}

