import Foundation
import UIKit

class Player {
    
    static let SIZE = 20
    
    var id: String
    var x: Int
    var y: Int
    var tagger: Bool = false // 술래
    var color: UIColor = UIColor.black
    
    init(_ data: RoomMemberInfo) {
        self.id = data.uid ?? ""
        self.x = data.positionX
        self.y = data.positionY
        self.tagger = false
        self.color = UIColor.black
    }
    
    func setPosition(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

