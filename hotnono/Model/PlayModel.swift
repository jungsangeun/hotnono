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
    
    func getEmptyPosition() -> (x: Int, y: Int) {
        // TODO 겹치지 않게 랜덤으로 토해내기
        return (0, 0)
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
        if (nX < 0 || nX > PlayGroundView.SIZE
            || nY < 0 || nY > PlayGroundView.SIZE) {
            return nil
        }
        // TODO 밖으로 안 벗어나게 처리
        return (nX, nY, member.status)
    }
    
    func update(member: RoomMemberInfo) {
        guard let uid = member.uid else { return }
        members[uid] = member
        
        // TODO 충돌 체크
    }
}

enum Direction {
    case Left, Top, Right, Bottom
}
