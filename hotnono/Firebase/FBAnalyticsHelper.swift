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
    
    func setUserID(_ userID: String) {
        Analytics.setUserID(userID)
    }
    
    func setUserProperties() {
        Analytics.setUserProperty("iOS", forName: "platform")
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        Analytics.setUserProperty(version, forName: "version")
    }
    
    func logEvent(_ name: String, _ parameters: [String:Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
