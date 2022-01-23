//
//  registMailViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.
//


import UIKit
import Firebase
import FirebaseAuth

class RegistMailViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var goCheckButton: UIButton!
        
    var auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
            
        mailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        
        UIBuild()
        hideKeyboardWhenTappedAround()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordAgainTextField.resignFirstResponder()
        return true
        
    }
    
    //新規ユーザー登録
    @IBAction func goCheckAction(_ sender: Any) {
        
        //インスタンス化
        let email = mailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordCheck = passwordAgainTextField.text ?? ""
        
        //もし全てのTextFieldの値がnilでない場合
        //パスワードが二つとも一致している
        if email.isEmpty != true && password.isEmpty != true && passwordCheck.isEmpty != true && password == passwordCheck  {
            
            //パスワードを5桁以上13桁未満へ
            // 文字数最大を決める.
            let maxLength: Int = 12
            let minLength: Int = 4

            // 入力済みの文字と入力された文字を合わせて取得.
            let str = passwordTextField.text!

            // 文字数が正しければtrueを返す.
            if minLength < str.count && str.count < maxLength {
                //この条件内ならok
            }else{
                let alert = UIAlertController(title: "", message: "5文字以上12文字以内で入力してください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                
                print("5文字以上12文字以内にして下さい")
                return
            }
            
            //新規ユーザ作成
            //FirebaseAuthの中にuserIDと、メールアドレス、パスワードを入れる
            Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
            
                //ログインできていたら
                if error == nil, let _ = result {
                    
                    //確認メールの送信
                    result?.user.sendEmailVerification(completion: {(error) in
                        if error == nil {
                            
                            let alert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                        }
                        
                    })
//                    //ユーザーIDの取得
//                     let userID = Auth.auth().currentUser?.uid
//                        print("Current user id is \(String(describing: userID))")
//                     UserDefaults.standard.set(userID, forKey: "userID")
                    
                } else {
                    print(error?.localizedDescription as Any)
                    return
                    //アラート
                }
                
                //画面遷移
                    let CheckMailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckMailViewController") as! CheckMailViewController
                    self.present(CheckMailViewController, animated: true, completion: nil)
                
            }
            
        }else{
            //一つでも空があるならば振動させる
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            print("振動")
            
            if mailTextField.text!.isEmpty {
                let alert = UIAlertController(title: "", message: "メールアドレスが入力されていません。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("メールアドレスが入力されていません")
                return
            } else if passwordTextField.text!.isEmpty {
                let alert = UIAlertController(title: "", message: "パスワードが入力されていません。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("パスワードが入力されていません")
                return
            } else if passwordAgainTextField.text!.isEmpty {

                print("パスワードが入力されていません")
                return
            } else if password != passwordCheck {
                let alert = UIAlertController(title: "", message: "パスワードが一致していません。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("パスワードが一致していません")
                return
            }

            return
        }
        
    }
    

    @IBAction func backAction(_ sender: Any) {
        
        sendLeftFromRight()
        dismiss(animated: false, completion: nil)
    }
    
    func UIBuild() {
    
        goCheckButton.layer.cornerRadius = 18.0
        
        //UIButton
        goCheckButton.layer.borderColor = UIColor.white.cgColor
        goCheckButton.layer.borderWidth = 1.5
        goCheckButton.layer.cornerRadius = 18
        goCheckButton.layer.shadowColor = UIColor.lightGray.cgColor
        goCheckButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        goCheckButton.layer.shadowOpacity = 0.7
        goCheckButton.layer.shadowRadius = 10
        
    }
    

}




