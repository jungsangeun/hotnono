//
//  CommonActionBar.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CommonActionBar: UIView {
    
    @IBOutlet weak var viewController:UIViewController!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBAction func close(_ sender: Any) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: CommonActionBar.self)
        bundle.loadNibNamed(String(describing: CommonActionBar.self), owner: self, options: nil)
        addSubview(rootView)
        
        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
