//
//  PlayGroundView.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 10..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import Foundation
import UIKit

class PlayGroundView: UIView {
    
    var players: [String: RoomMemberInfo] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        drawPlayground(rect)
        drawPlayers(rect)
    }
    
    func update(member: RoomMemberInfo) {
        guard let uid = member.uid else { return }
        players[uid] = member
        setNeedsDisplay()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
    }
    
    private func drawPlayground(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.black.setStroke()
        path.lineWidth = 1
        path.stroke()
    }
    
    private func drawPlayers(_ rect: CGRect) {
        for p in players {
            let player = p.value
            var color: UIColor = .black
            if player.isTagger {
                color = .red
            } else if player.isMe {
                color = .blue
            } else {
                color = .black
            }
            if player.status == .Die {
                color.withAlphaComponent(0.3).setFill()
            } else {
                color.setFill()
            }
            let path = UIBezierPath(ovalIn: CGRect(x: player.positionX, y: player.positionY, width: PlayModel.PLAYER_SIZE, height: PlayModel.PLAYER_SIZE))
            path.fill()
        }
    }
}
