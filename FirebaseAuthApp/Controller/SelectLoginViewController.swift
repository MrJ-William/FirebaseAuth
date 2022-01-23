//
//  ViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.
//

import UIKit
import Firebase

class SelectLoginViewController: UIViewController {

    @IBOutlet weak var newLoginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIBuild()
    }
    
   
    @IBAction func newLogin(_ sender: Any) {
        performSegue(withIdentifier: "newLoginVC", sender: nil)
        sendRightFromLeft()
    }
    
    @IBAction func selectLogin(_ sender: Any) {
        performSegue(withIdentifier: "selectLoginVC", sender: nil)
        sendRightFromLeft()
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: nil, completion: nil)
        sendLeftFromRight()
    }
    
    func UIBuild() {
        //UIButton
        newLoginButton.layer.borderColor = UIColor.white.cgColor
        newLoginButton.layer.borderWidth = 1.5
        newLoginButton.layer.cornerRadius = 18
        newLoginButton.layer.shadowColor = UIColor.black.cgColor
        newLoginButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        newLoginButton.layer.shadowOpacity = 0.7
        newLoginButton.layer.shadowRadius = 10
        
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 1.5
        signInButton.layer.cornerRadius = 18
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOffset = CGSize(width: 1, height: 3)
        signInButton.layer.shadowOpacity = 0.7
        signInButton.layer.shadowRadius = 10
    }
    
}
