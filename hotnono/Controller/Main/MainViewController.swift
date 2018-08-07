//
//  ViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: BaseViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func clickEmailJoin(_ sender: Any) {
    }
    
    @IBAction func clickGoogleJoin(_ sender: Any) {
    }
    
    
    var handleAuth:AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stateLabel.text = "로그인\n확인 중.."
    }

    override func viewWillAppear(_ animated: Bool) {
        handleAuth = Auth.auth().addStateDidChangeListener{
            (auth, user) in
                dump(user)
        }
        
        if let user = Auth.auth().currentUser {
            // User is signed in.
            stateLabel.text = "확인 완료.\n잠시만\n기다려주세요."
            
        } else {
            // No user is signed in.
            stateLabel.text = "환영합니다."
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

