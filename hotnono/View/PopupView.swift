//
//  PopupView.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 9..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class PopupView: UIView {
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submitButton: MDCButton! {
        get {
            return self.submitButton
        }
        set(component) {
            MaterialDesignUtil.applyButtonTheme(component)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
        submit?()
    }
    
    var submit: (()->())?
}
