//
//  MainPageViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.
//

import UIKit
import Firebase

class MainPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "userID") != nil{
            
            let userID = UserDefaults.standard.object(forKey: "userID") as! String
            print(userID)
            
        }else{
            
            // 画面遷移
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let next: WolkThroughViewController = storyboard.instantiateInitialViewController() as! WolkThroughViewController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: false, completion: nil)
            print("画面遷移")
            
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        
        //アラートを出す
        let alert: UIAlertController = UIAlertController(title: "ログアウト", message: "ログアウトします。よろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        
        // OKボタン
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) -> Void in
            
            do{
                try Auth.auth().signOut()
                
            }catch let error as NSError{
                print(error)
            }
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let next: WolkThroughViewController = storyboard.instantiateInitialViewController() as! WolkThroughViewController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
            
            print("Logout")
        })
        
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
