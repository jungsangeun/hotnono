//
//  FBAuthenticationHelper.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import Firebase

class FBAuthenticationHelper {
    
    static let sharedInstance = FBAuthenticationHelper()
    
    var handleAuth:AuthStateDidChangeListenerHandle
    
    init() {
        print("Created FBAuthenticationHelper");
        
        handleAuth = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            print("addStateDidChangeListener %@", user ?? "user is nil")
        }
    }
    
    func destroy() {
        Auth.auth().removeStateDidChangeListener(handleAuth)
    }
    
    func getCurrentUser() -> User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return user
    }
    
    func isSignIn() -> Bool {
        guard getCurrentUser() != nil else {
            return false
        }
        return true
    }
    
    func signInEmail(email: String, password: String, success: @escaping (User) -> (), fail: @escaping (Error) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                fail(error)
            } else {
                if let ret = user?.user {
                    success(ret)
                } else {
                    fail(FBAuthError.nilUser(reason: "User is nil"))
                }
            }
        }
    }
    
    func signUpEmail(email: String, password: String, success: @escaping (User?) -> (), fail: @escaping (Error) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse :
                        self.signInEmail(email: email, password: password, success: success, fail: fail)
                    default:
                        fail(error)
                    }
                }
            } else {
                if let ret = user?.user {
                    success(ret)
                } else {
                    fail(FBAuthError.nilUser(reason: "User is nil"))
                }
            }
        }
    }
    
    func signUpGoogle() {
        // TODO
    }
    
    func signOut() {
        // TODO
    }
}

enum FBAuthError: Error {
    case nilUser(reason: String)
}

