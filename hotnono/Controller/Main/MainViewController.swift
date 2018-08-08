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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        signUp(email, password)
    }
    
    @IBAction func clickGoogleJoin(_ sender: Any) {
        
    }
    
    
    var handleAuth:AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        stateLabel.text = "로그인\n확인 중."
        
        handleAuth = Auth.auth().addStateDidChangeListener{
            (auth, user) in
                print("addStateDidChangeListener ")
                print(user)
        }
        
        if let user = Auth.auth().currentUser {
            // User is signed in.
            stateLabel.text = "잠시만\n기다려\n주세요."
            moveNext(user: user)
        } else {
            // No user is signed in.
            stateLabel.text = "환영\n합니다."
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func signUp(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse :
                        self.signIn(email, password)
                    default:
                        self.stateLabel.text = "오류:("
                        self.showAlertPopup(message: error.localizedDescription)
                    }
                }
            } else {
                if let user = user?.user {
                    self.showAlertPopup(message: "회원 가입 완료!")
                    self.moveNext(user: user)
                } else {
                    self.showAlertPopup(message: "다시 시도해 주세요 :(")
                }
            }
        }
    }
    
    private func signIn(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.stateLabel.text = "오류:("
                self.showAlertPopup(message: error.localizedDescription)
            } else {
                if let user = user?.user {
                    self.showAlertPopup(message: "로그인 완료!")
                    self.moveNext(user: user)
                } else {
                    self.showAlertPopup(message: "다시 시도해 주세요 :(")
                }
            }
        }
    }
    
    private func moveNext(user: User) {
    }
}

