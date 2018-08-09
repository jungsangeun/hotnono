//
//  ViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class MainViewController: BaseViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailButton: MDCButton!
    @IBOutlet weak var googleButton: MDCButton!
    
    @IBAction func clickEmailJoin(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        FBAuthenticationHelper.sharedInstance.signUpEmail(email: email,password: password,
                                                          success: { (user) in
                                                            self.stateLabel.text = "반가워요\n:)"
                                                            self.showAlertPopup(message: "인증이 완료 되었습니다!") {
                                                                self.performSegue(withIdentifier: "segueMainToReady", sender: nil)
                                                            }
        },
                                                          fail: { (error) in
                                                            self.stateLabel.text = "윽:("
                                                            self.showAlertPopup(message: error.localizedDescription)
        })
    }
    
    @IBAction func clickGoogleJoin(_ sender: Any) {
        // TODO
        self.showAlertPopup(message: "준비중:$")
    }
    
    var isAutoReady = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MaterialDesignUtil.applyButtonTheme(emailButton)
        MaterialDesignUtil.applyButtonTheme(googleButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAutoReady {
            isAutoReady = false
            if FBAuthenticationHelper.sharedInstance.isSignIn() {
                if let user = FBAuthenticationHelper.sharedInstance.getCurrentUser() {
                    self.emailTextField.text = user.email
                }
                stateLabel.text = "잠시만요"
                performSegue(withIdentifier: "segueMainToReady", sender: nil)
            } else {
                stateLabel.text = "시작\n하세요:)"
            }
        } else {
            stateLabel.text = "시작\n하세요:)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainToReady" {
            let _ = segue.destination as! ReadyViewController
        }
    }
}

