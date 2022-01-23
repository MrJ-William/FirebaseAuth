//
//  CheckMailViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.


import UIKit
import Firebase
import FirebaseAuth

class CheckMailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()

    }
    
    //メール確認後にこれを表示する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "メール認証が完了したら次へで進んでください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        //画面再読み込み

        if auth.currentUser != nil {
            auth.currentUser?.reload(completion: { error in
                if error == nil {
                    //メール認証が成功している時
                    if self.auth.currentUser?.isEmailVerified == true {
                        
                        //ユーザーIDの取得
                        let userID = Auth.auth().currentUser?.uid
                        print("Current user id is \(String(describing: userID))")
                        UserDefaults.standard.set(userID, forKey: "userID")
                        
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let next: MainPageViewController = storyboard.instantiateInitialViewController() as! MainPageViewController
                        next.modalPresentationStyle = .fullScreen
                        self.present(next, animated: true, completion: nil)
                        
                    } else if self.auth.currentUser?.isEmailVerified == false {
                    //メール認証が成功していない時
                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    //再送信する
    @IBAction func sendAgainAction(_ sender: Any) {
    }
    
}

