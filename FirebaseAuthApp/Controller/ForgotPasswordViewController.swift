//
//  forgotPasswordViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.

import UIKit
import FirebaseAuth
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()

        mailTextField.delegate = self
        mailTextField.underlined()
        
        UIBuild()
        hideKeyboardWhenTappedAround()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        mailTextField.resignFirstResponder()
        return true
        
    }


    @IBAction func sendAction(_ sender: Any) {
        let resetEmail = mailTextField.text!
        
//        パスワード変更の為にfirebaseからメールを送る
        auth.sendPasswordReset(withEmail: resetEmail, completion: { (error) in
            DispatchQueue.main.async {
                if error != nil {

                    let alert = UIAlertController(title: "メールを送信しました", message: "メールでパスワードの再設定を行ってください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    print("メールを送信しました。メールでパスワードの再設定を行ってください。")

                } else {
                    print("nil")
                    print("このメールアドレスは登録されてません。")

                    let alert = UIAlertController(title: "メールが確認できません", message: "再度入力してください。間違っている可能性があります", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        })
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        sendLeftFromRight()
        dismiss(animated: false, completion: nil)
    }
   
    func UIBuild() {
        //UIButton
        sendButton.layer.borderColor = UIColor.white.cgColor
        sendButton.layer.borderWidth = 1.5
        sendButton.layer.cornerRadius = 18
        sendButton.layer.shadowColor = UIColor.lightGray.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        sendButton.layer.shadowOpacity = 0.7
        sendButton.layer.shadowRadius = 10
        
    }

}
