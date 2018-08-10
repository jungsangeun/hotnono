//
//  PlayViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 9..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class PlayViewController: BaseViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var quitButton: MDCButton!
    @IBOutlet weak var leftButton: MDCButton!
    @IBOutlet weak var topButton: MDCButton!
    @IBOutlet weak var rightButton: MDCButton!
    @IBOutlet weak var bottomButton: MDCButton!
    
    @IBAction func clickQuit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickLeft(_ sender: Any) {
        
    }
    
    @IBAction func clickTop(_ sender: Any) {
        
    }
    
    @IBAction func clickRight(_ sender: Any) {
        
    }
    
    @IBAction func clickBottom(_ sender: Any) {
        
    }
    
    var code: String?
    var roomUid: String?
    
    override func viewDidLoad() {
        MaterialDesignUtil.applyButtonTheme(quitButton)
        MaterialDesignUtil.applyButtonTheme(leftButton)
        MaterialDesignUtil.applyButtonTheme(topButton)
        MaterialDesignUtil.applyButtonTheme(rightButton)
        MaterialDesignUtil.applyButtonTheme(bottomButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        codeLabel.text = String(format:"%s[%s]",code ?? "",roomUid ?? "")
    }
}
