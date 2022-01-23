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
        startButton.layer.cornerRadius = 18

    }
    

    @IBAction func nextVC(_ sender: Any) {
        performSegue(withIdentifier: "explainVC", sender: nil)
    }
    

}
