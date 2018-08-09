//
//  PopupView.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 9..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit

class PopupView: UIView {
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
    }
}
