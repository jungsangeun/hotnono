//
//  SplashViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 9..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    override func viewDidLoad() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { (Timer) in
            self.performSegue(withIdentifier: "segueSplashToMain", sender: nil)
        })
    }
}
