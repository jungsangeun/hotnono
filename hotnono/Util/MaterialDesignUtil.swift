//
//  MaterialDesignUtil.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 10..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialButtons_ColorThemer

class MaterialDesignUtil {
    
    static func applyButtonTheme(_ button: MDCButton) {
        MDCOutlinedButtonThemer.applyScheme(MDCButtonScheme(), to: button)
        let colorScheme = MDCSemanticColorScheme()
        colorScheme.primaryColor = UIColor.black
        MDCTextButtonColorThemer.applySemanticColorScheme(colorScheme, to: button)
    }
    
    static func applyTextButtonTheme(_ button: MDCButton) {
        MDCTextButtonThemer.applyScheme(MDCButtonScheme(), to: button)
        let colorScheme = MDCSemanticColorScheme()
        colorScheme.primaryColor = UIColor.white
        MDCTextButtonColorThemer.applySemanticColorScheme(colorScheme, to: button)
    }
}
