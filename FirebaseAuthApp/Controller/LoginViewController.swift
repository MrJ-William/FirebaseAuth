//
//  LoginViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.



import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import TextFieldEffects


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIBuild()
        //キーボード以外のタッチで閉じる
        hideKeyboardWhenTappedAround()

    }
    
    //returnキーを押した時にキーボードを閉じる
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           mailTextField.resignFirstResponder()
           passwordTextField.resignFirstResponder()
           return true
           
       }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        performSegue(withIdentifier: "toForget", sender: nil)

        }
    
    @IBAction func loginAction(_ sender: Any) {

        // 各TextFieldからメールアドレスとパスワードを取得
        let email = mailTextField.text
        let password = passwordTextField.text
        
        //FirebaseSDK 既存ユーザーのログイン
        Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
            if (result?.user) != nil {
                
                print(UserDefaults.standard.object(forKey: "userID") as Any)
                
                //ユーザーIDの取得
                let userID = Auth.auth().currentUser?.uid
                print("Current user id is \(String(describing: userID))")
                UserDefaults.standard.set(userID, forKey: "userID")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Cirecle", bundle: nil)
                let next: MenuNavigationController = storyboard.instantiateInitialViewController() as! MenuNavigationController
                
                let transition = CATransition()
                transition.duration = 0.2
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromLeft
                self.view.window!.layer.add(transition, forKey: kCATransition)
                       
                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true, completion: nil)
                
            }else {
                
                let alert = UIAlertController(title: "", message: "メールアドレス又はパスワードが間違っています。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("メールアドレス又はパスワードが間違っています。")
                return
            }
        }

    }
    
    
    @IBAction func backAction(_ sender: Any) {
        sendLeftFromRight()
        dismiss(animated: false, completion: nil)
    }
    
    func UIBuild() {
    
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        //UIButton
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.cornerRadius = 18
        loginButton.layer.shadowColor = UIColor.lightGray.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        loginButton.layer.shadowOpacity = 0.7
        loginButton.layer.shadowRadius = 10
    }
    
}
