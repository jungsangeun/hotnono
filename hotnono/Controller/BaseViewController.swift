//
//  BaseViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        
    }
    
    func showAlertPopup(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)

    }
}
