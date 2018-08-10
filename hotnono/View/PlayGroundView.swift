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
    
    static let SIZE = 260
    
    var status: PlayStatus = .Idle
    var playerCount: Int = 0
    var players: Array<Player> = []
    
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
    
    func joinPlayer(player: Player) {
        if status != .Idle {
            return
        }
        players.append(player)
        
        setNeedsDisplay()
    }
    
    func start() {
        status = .Playing
        playerCount = players.count
    }
    
    func movePlayer(id: String, dx: Int = 0, dy: Int = 0) {
        if status != .Playing {
            return
        }
        
        for p in players {
            if p.id == id {
                move(player: p, dx: dx, dy: dy)
            }
        }
        
        removePlayerIfCaught()
        
        setNeedsDisplay()
    }
    
    func stop() {
        status = .Finish
    }
    
    func reset() {
        status = .Idle
        players.removeAll()
        playerCount = 0
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
            p.color.setFill()
            let path = UIBezierPath(ovalIn: CGRect(x: p.x, y: p.y, width: Player.SIZE, height: Player.SIZE))
            path.fill()
        }
    }
    
    private func move(player: Player, dx: Int, dy: Int) {
        var x = 0
        var y = 0
        
        if dx > 0 {
            if player.x + Player.SIZE < PlayGroundView.SIZE {
                x = dx
            }
        } else {
            if (player.x > 0) {
                x = dx
            }
        }
        
        if dy > 0 {
            if (player.y + Player.SIZE < PlayGroundView.SIZE) {
                y = dy
            }
        } else {
            if (player.y > 0) {
                y = dy
            }
        }
        
        player.move(dx: x, dy: y)
    }
    
    private func removePlayerIfCaught() {
        
    }
}

enum PlayStatus {
    case Idle, Playing, Finish
}
