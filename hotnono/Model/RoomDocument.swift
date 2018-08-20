//
//  RoomDocument.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 19..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation

class RoomDocument {
    
    var id: String = ""
    var owner: String = ""
    var status: Status = .Idle
    
    init(id: String, owner: String) {
        self.id = id
        self.owner = owner
        self.status = .Idle
    }
    
    init(id: String, data: [String:Any]?) {
        self.id = id
        
        if let data = data {
            if let owner = data["owner"] {
                self.owner = owner as? String ?? ""
            }
            if let status = data["status"] {
                self.status = Status(rawValue: status as? Int ?? Status.Idle.rawValue) ?? Status.Idle
            }
        }
    }
    
    func toData() -> [String:Any] {
        return ["owner": owner, "status": status.rawValue]
    }
    
    enum Status: Int {
        case Idle = 0
        case Playing = 1
    }
}
