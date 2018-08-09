//
//  ReadyViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 8..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class ReadyViewController: BaseViewController {
    
    @IBOutlet weak var createButton: MDCButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var joinButton: MDCButton!
    @IBOutlet weak var backToSignInButton: MDCButton!
    
    @IBAction func clickCreate(_ sender: Any) {
        performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
    }
    
    @IBAction func clickJoin(_ sender: Any) {
        performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
    }
    
    @IBAction func clickQuit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MaterialDesignUtil.applyButtonTheme(createButton)
        MaterialDesignUtil.applyButtonTheme(joinButton)
        MaterialDesignUtil.applyButtonTheme(backToSignInButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReadyToPlay" {
            let vc = segue.destination as! PlayViewController
            vc.code = codeTextField.text
        }
    }
}
