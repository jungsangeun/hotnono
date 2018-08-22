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
    var status: Status = Status.Idle
    
    var initX: Int = 0
    var initY: Int = 0
    var isTagger = false
    var isMe = false
    
    init(uid: String = "") {
        self.uid = uid
    }
    
    init(_ data: [String:Any?]) {
        if let uid = data["uid"] {
            self.uid = uid as? String
        }
        if let name = data["name"] {
            self.name = name as? String
        }
        if let x = data["position_x"] {
            self.positionX = x as? Int ?? 0
        }
        if let y = data["position_y"] {
            self.positionY = y as? Int ?? 0
        }
        if let status = data["status"] {
            self.status = Status(rawValue: status as? Int ?? Status.Idle.rawValue) ?? Status.Idle
        }
    }
    
    enum Status :Int{
        case Idle = 0
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
