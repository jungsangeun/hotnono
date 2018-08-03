//
//  ViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50))
        webView.backgroundColor = UIColor.clear
        containerView.addSubview(webView)
        
        webView.loadRequest(URLRequest(url: URL(string: "https://maps.darksky.net/@temperature,40.219,-231.200,4")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

