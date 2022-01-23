//
//  WolkThroughViewController.swift
//  FirebaseAuthApp
//
//  Created by yuji suzuki on 2022/01/23.
//

import UIKit

class WolkThroughViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UIBuild()

    }
    

    @IBAction func nextVC(_ sender: Any) {
        performSegue(withIdentifier: "explainVC", sender: nil)
        sendRightFromLeft()
    }
    
    func UIBuild() {
        startButton.layer.cornerRadius = 18
    }
    

}
