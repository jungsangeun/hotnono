import Foundation
import UIKit
//import RxSwift

class Player {
    
    static let SIZE = 20
    
    var id: String
    var x: Int
    var y: Int
    var tagger: Bool = false // 술래
    var color: UIColor = UIColor.red
    
//    var disposable: Disposable
    
    init(id: String, x: Int = 0, y: Int = 0, tagger: Bool = false, color: UIColor = UIColor.red) {
        self.id = id
        self.x = x
        self.y = y
        self.tagger = tagger
        self.color = color
        
//        disposable = RxEvent.sharedInstance.getEvent(event: .MoveTagger, initValue: CGPoint(x: -1, y: -1))
//            .subscribe { (event) in
////                let point = event.element as! CGPoint
////                if (self.x < point.x. && point.x < self.x+Player.SIZE) {
////
////                }
//        }
    }
    
    func move(dx: Int=0, dy: Int=0) {
        x += dx
        y += dy
    }
    
    func destroy() {
//        disposable.dispose()
    }
}

