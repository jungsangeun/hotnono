//
//  MembersModel.swift
//  hotnono
//
//  Created by zic325 on 2018. 8. 12..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import FirebaseFirestore

class PlayModel {
    
    static let BOARD_SIZE = 260
    static let PLAYER_SIZE = 20
    static let MAX_COUNT = 4
    static let MOVE_DISTANCE = 10
    
    var myId: String
    var ownerId: String
    var members: [String: RoomMemberInfo] = [:]
    
    init(myId: String, ownerId: String, documents: [QueryDocumentSnapshot]) {
        self.myId = myId
        self.ownerId = ownerId
        for doc in documents {
            let member = RoomMemberInfo(doc.data())
            if let uid = member.uid {
                members[uid] = member
            }
        }
    }
    
    func isJoinable() -> Bool {
        return members.count < PlayModel.MAX_COUNT
    }
    
    func isJoined(member: RoomMemberInfo) -> Bool {
        if let uid = member.uid, let _ = members[uid] {
            return true
        } else {
            return false
        }
    }
    
    func isCaught(member: RoomMemberInfo) -> Bool {
        if let uid = member.uid, uid != ownerId {
            let tagger = members[ownerId]
            if (member.positionX == tagger?.positionX
                && member.positionY == tagger?.positionY) {
                return true
            }
        }
        return false
    }
    
    func getEmptyPosition() -> (x: Int, y: Int) {
        let count = members.count
        switch count {
        case 1:
            return (PlayModel.BOARD_SIZE - PlayModel.PLAYER_SIZE, 0)
        case 2:
            return (0, PlayModel.BOARD_SIZE - PlayModel.PLAYER_SIZE)
        case 3:
            return (PlayModel.BOARD_SIZE - PlayModel.PLAYER_SIZE, PlayModel.BOARD_SIZE - PlayModel.PLAYER_SIZE)
        default:
            return (0, 0)
        }
    }
    
    func getPosition(direction: Direction) -> (x: Int, y: Int, status: RoomMemberInfo.Status)? {
        guard let member = members[myId] else { return nil }
        var nX = 0
        var nY = 0
        switch direction {
        case .Left:
            nX = member.positionX - PlayModel.MOVE_DISTANCE
            nY = member.positionY
        case .Top:
            nX = member.positionX
            nY = member.positionY - PlayModel.MOVE_DISTANCE
        case .Right:
            nX = member.positionX + PlayModel.MOVE_DISTANCE
            nY = member.positionY
        case .Bottom:
            nX = member.positionX
            nY = member.positionY + PlayModel.MOVE_DISTANCE
        }
        print("nX: \(nX) nY: \(nY)")
        if (nX < 0 || nX > PlayModel.BOARD_SIZE - PlayModel.PLAYER_SIZE
            || nY < 0 || nY > PlayModel.BOARD_SIZE - PlayModel.PLAYER_SIZE) {
            return nil
        }
        return (nX, nY, member.status)
    }
    
    func update(member: RoomMemberInfo) {
        guard let uid = member.uid else { return }
        members[uid] = member
        
        var caughtCount = 0
        for m in members {
            if (m.value.status == .Die) {
                caughtCount += 1
            }
        }
        
        if (caughtCount > members.count - 1) {
            RxEvent.sharedInstance.sendEvent(event: .CatchAllPlayer, data: true)
        }
    }
}

enum Direction {
    case Left, Top, Right, Bottom
}
