//
//  FBCrashlyticsHelper.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 3..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class FBCrashlyticsHelper {
    
    static func commInit() {
        Fabric.with([Crashlytics.self])
        if let uid = FBAuthenticationHelper.sharedInstance.getCurrentUser()?.uid {
            setUserIdentifier(identifier: uid)
        }
        #if DEBUG
            Fabric.sharedSDK().debug = true
        #endif
    }
    
    static func setUserIdentifier(identifier: String) {
        Crashlytics.sharedInstance().setUserIdentifier(identifier)
    }
    
    static func testing() {
        Crashlytics.sharedInstance().crash()
    }
}
