//
//  FBAnalyticsHelper.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import Firebase

class FBAnalyticsHelper {
    
    static func commInit() {
        if let uid = FBAuthenticationHelper.sharedInstance.getCurrentUser()?.uid {
            setUserProperties(uid)
        }
    }
    
    static func setUserProperties(_ userID: String) {
        Analytics.setUserProperty("iOS", forName: "platform")
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        Analytics.setUserProperty(version, forName: "version")
        
        Analytics.setUserID(userID)
    }
    
    static func logEvent(_ name: String, _ parameters: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
