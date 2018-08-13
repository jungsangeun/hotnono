//
//  RoomMemberInfo.swift
//  hotnono
//
//  Created by hankoojung_nbt on 2018. 8. 10..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import CoreGraphics

class RoomMemberInfo {
    
    var uid: String?
    var name: String?
    var positionX: Int = 0
    var positionY: Int = 0
    var status: Status = Status.Live
    
    var isTagger = false
    var isMe = false
    
    init(uid: String = ""){
        self.uid = uid
    }
    
    init(_ data: [String:Any?]) {
        uid = data["uid"] as! String
        //name = data["name"] as! String
        positionX = data["position_x"] as! Int
        positionY = data["position_y"] as! Int
        status = Status(rawValue: data["status"] as! Int) ?? Status.Die
    }
    
    enum Status :Int{
        case Live = 1
        case Die = 2
        case Cold = 3
    }
    
    func toData() -> [String : Any]{
        var data:[String:Any] = [:]
        data["uid"] = uid
        data["name"] = name
        data["position_x"] = positionX
        data["position_y"] = positionY
        data["status"] = status.rawValue
        return data
    }
}
