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
    
    func showAlertPopup(message: String, submit: (()->())? = nil) {
        let popup = UINib(nibName: "PopupView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PopupView
        
        popup.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        popup.frame = self.view.frame
        
        popup.baseView.backgroundColor = UIColor.white
        popup.baseView.layer.cornerRadius = 9.0
        
        popup.messageLabel.text = message
        popup.submit = submit
        
        self.view.addSubview(popup)
    }
}
