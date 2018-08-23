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
    
    var myId: String = ""
    var ownerId: String = ""
    var status: RoomDocument.Status = RoomDocument.Status.Idle
    var members: [String: RoomMemberInfo] = [:]
    
    func isOwner() -> Bool {
        return !myId.isEmpty && myId == ownerId
    }
    
    func isPlaying() -> Bool {
        return status == .Playing
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
    
    func update(member: RoomMemberInfo, roomsDocId: String) {
        guard let uid = member.uid else { return }
        members[uid] = member
        
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId)
        if (isOwner()) {
            var caughtCount = 0
            for m in members {
                let value = m.value
                if value.status != .Die {
                    let isCaught = self.isCaught(member: value)
                    if isCaught {
                        roomRef.collection(FBFirestoreHelper.MEMBER_PATH).document(value.uid ?? "")
                            .updateData(["status": RoomMemberInfo.Status.Die.rawValue])
                        caughtCount += 1
                    }
                }
            }
            
            if (caughtCount >= 1 && caughtCount >= members.count - 1) {
                roomRef.updateData(["status":RoomDocument.Status.CatchAll.rawValue])
            }
        }
    }
    
    func getMe() -> RoomMemberInfo? {
        return members[myId]
    }
}

enum Direction {
    case Left, Top, Right, Bottom
}
