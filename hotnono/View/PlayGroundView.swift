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
    var players: [String: Player] = [:]
    
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
        players[player.id] = player
        
        setNeedsDisplay()
    }
    
    func start() {
        status = .Playing
        playerCount = players.count
    }
    
    func movePlayer(id: String, x: Int = 0, y: Int = 0) {
        if status != .Playing {
            return
        }
        
        guard let p = players[id] else { return }
        p.setPosition(x: x, y: y)
        
        setNeedsDisplay()
    }
    
    func removePlayer(id: String) {
        players.removeValue(forKey: id)
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
            let player = p.value
            player.color.setFill()
            let path = UIBezierPath(ovalIn: CGRect(x: player.x, y: player.y, width: Player.SIZE, height: Player.SIZE))
            path.fill()
        }
    }
}

enum PlayStatus {
    case Idle, Playing, Finish
}
