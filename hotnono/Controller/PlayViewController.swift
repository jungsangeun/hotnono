//
//  PlayViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 9..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import FirebaseAuth
import FirebaseFirestore
import RxSwift

class PlayViewController: BaseViewController {
    
    var roomsDocId: String? //현재 Room Uid
    var ownerId: String?
    var roomMonitoringSubscribe : ListenerRegistration? = nil //방 정보 모니터링 Subscribe
    var roomMemberMonitoringSubscribe : ListenerRegistration? = nil //방 멤버 정보 모니터링 Subscribe
    var user: User? = FBAuthenticationHelper.sharedInstance.getCurrentUser()
    var playModel: PlayModel?
    var compositeDisposable: CompositeDisposable = CompositeDisposable()
    
    @IBOutlet weak var playgroundView: PlayGroundView!
    @IBOutlet weak var quitButton: MDCButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var leftButton: MDCButton!
    @IBOutlet weak var topButton: MDCButton!
    @IBOutlet weak var rightButton: MDCButton!
    @IBOutlet weak var bottomButton: MDCButton!
    @IBOutlet weak var playButton: MDCButton!
    @IBOutlet weak var finishButton: MDCButton!
    @IBOutlet weak var resetButton: MDCButton!
    
    @IBAction func clickStart(_ sender: Any) {
        start()
    }
    
    @IBAction func clickStop(_ sender: Any) {
        stop()
    }
    
    @IBAction func clickReset(_ sender: Any) {
        reset()
    }
    
    @IBAction func clickQuit(_ sender: Any) {
        leaveGame()
    }
    
    @IBAction func clickLeft(_ sender: Any) {
        guard let isPlaying = playModel?.isPlaying(), isPlaying else { return }
        guard let (x, y, status) = playModel?.getPosition(direction: .Left) else { return }
        self.updateMe(x: x, y: y, status: status)
    }
    
    @IBAction func clickTop(_ sender: Any) {
        guard let isPlaying = playModel?.isPlaying(), isPlaying else { return }
        guard let (x, y, status) = playModel?.getPosition(direction: .Top) else { return }
        self.updateMe(x: x, y: y, status: status)
    }
    
    @IBAction func clickRight(_ sender: Any) {
        guard let isPlaying = playModel?.isPlaying(), isPlaying else { return }
        guard let (x, y, status) = playModel?.getPosition(direction: .Right) else { return }
        self.updateMe(x: x, y: y, status: status)
    }
    
    @IBAction func clickBottom(_ sender: Any) {
        guard let isPlaying = playModel?.isPlaying(), isPlaying else { return }
        guard let (x, y, status) = playModel?.getPosition(direction: .Bottom) else { return }
        self.updateMe(x: x, y: y, status: status)
    }
    
    override func viewDidLoad() {
        guard let roomsDocId = roomsDocId else {
            print("roomsDocId is nil")
            showAlertPopup(message: "방 번호가 잘못 되었습니다 :(") {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        //라벨 설정
        codeLabel.text = String(format:"방번호 %@", roomsDocId)
        
        applyMaterialTheme() // 매터리얼 테마 적용
        subscribeEvent() // 게임 관련 이벤트 구독
        
        guard let userUid = self.user?.uid else {
            self.showAlertPopup(message: "Empty userUid")
            return
        }
        
        playModel = PlayModel()
        playModel?.myId = userUid
        
        startDBMonitoring(roomsDocId: roomsDocId) //현재 방 변화 모니터링
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        compositeDisposable.dispose()
        RxEvent.sharedInstance.clearAll()
    }
    
    private func applyMaterialTheme() {
        MaterialDesignUtil.applyButtonTheme(quitButton)
        
        MaterialDesignUtil.applyButtonTheme(playButton)
        MaterialDesignUtil.applyButtonTheme(finishButton)
        MaterialDesignUtil.applyButtonTheme(resetButton)
        
        MaterialDesignUtil.applyButtonTheme(leftButton)
        MaterialDesignUtil.applyButtonTheme(topButton)
        MaterialDesignUtil.applyButtonTheme(rightButton)
        MaterialDesignUtil.applyButtonTheme(bottomButton)
    }
    
    private func subscribeEvent() {
        
    }
    
    //방 모니터링 시작
    func startDBMonitoring(roomsDocId: String) {
        let db = Firestore.firestore()
        //방 정보 모니터링
        roomMonitoringSubscribe = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot?.data() else {
                    self.showAlertPopup(message: "방이 폭파 되었습니다 :(") {
                        self.dismiss(animated: true, completion: nil)
                    }
                    print("Error fetching document: \(error.debugDescription)")
                    return
                }
                
                print("Room Monitoring: \(document)") //변경된 방 정보 출력
                
                self.playModel?.ownerId = document["owner"] as? String ?? ""
                self.playModel?.status = RoomDocument.Status(rawValue:
                    document["status"] as? Int ?? RoomDocument.Status.Idle.rawValue) ?? RoomDocument.Status.Idle
                
                guard let status = self.playModel?.status else { return }
                switch status {
                case .Idle:
                    if (self.playModel?.isOwner() ?? false) {
                        self.playButton.isEnabled = true
                    } else {
                        self.playButton.isEnabled = false
                    }
                    
                    self.finishButton.isEnabled = false
                    self.resetButton.isEnabled = false
                    
                    if let me = self.playModel?.getMe() {
                        self.updateMe(x: me.initX, y: me.initY, status: .Idle)
                    }
                case .Playing:
                    print("Playing")
                case .CatchAll:
                    let isOwner = self.playModel?.isOwner() ?? false
                    let message = isOwner ? "다 잡았다!! :)" : "다 잡혔다 :("
                    self.showAlertPopup(message: message) {
                        self.reset()
                    }
                }
        }
        
        //방 멤버 정보 변경 모니터링
        roomMemberMonitoringSubscribe = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId)
            .collection(FBFirestoreHelper.MEMBER_PATH)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                //변경된 멤버 정보 출력
                for document in document.documents {
                    print(String(format: "updated member: %@", document.data()))
                    
                    let member = RoomMemberInfo(document.data())
                    member.isTagger = member.uid == self.playModel?.ownerId
                    member.isMe = member.uid == self.playModel?.myId
                        
                    self.playModel?.update(member: member, roomsDocId: self.roomsDocId ?? "")
                    self.playgroundView.update(member: member)
                }
        }
    }
    
    //방 모니터링 중단
    func stopDBMonitoring(){
        guard let roomSubscribe = roomMonitoringSubscribe else {return}
        roomSubscribe.remove()
        guard let roomMembersubscribe = roomMemberMonitoringSubscribe else {return}
        roomMembersubscribe.remove()
    }
    
    private func updateMe(x: Int?, y: Int?, status: RoomMemberInfo.Status) {
        if let user = self.playModel?.getMe() {
            user.positionX = x ?? 0
            user.positionY = y ?? 0
            user.status = status
            uploadMemberInfo(memberInfo: user)
        }
    }
    
    func uploadMemberInfo(memberInfo: RoomMemberInfo) {
        
        //Room Uid 체크
        guard let roomsDocId = roomsDocId else {
            print("roomsDocId is nil")
            return
        }
        
        //Memeber Uid 체크
        guard let memberUid = memberInfo.uid else {
            print("Memeber Uid is nil")
            return
        }
        
        let db = Firestore.firestore()
        db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId).collection(FBFirestoreHelper.MEMBER_PATH)
            .document(memberUid).setData(memberInfo.toData())
    }
    
    private func start() {
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(self.roomsDocId ?? "")
        roomRef.updateData(["status":RoomDocument.Status.Playing.rawValue])
        
        playButton.isEnabled = false
        finishButton.isEnabled = true
    }
    
    private func stop() {
        finishButton.isEnabled = false
        resetButton.isEnabled = true
    }
    
    private func reset() {
        if let _ = self.playModel?.isOwner() {
            let db = Firestore.firestore()
            let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(self.roomsDocId ?? "")
            roomRef.updateData(["status":RoomDocument.Status.Idle.rawValue])
        }
    }
    
    private func leaveGame() {
        guard let uid = FBAuthenticationHelper.sharedInstance.getCurrentUser()?.uid else {
            print("Error load uid")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let db = Firestore.firestore()
        if uid == ownerId {
            // 방 폭파
            db.collection(FBFirestoreHelper.ROOM_PATH).document(self.roomsDocId ?? "")
                .delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        } else {
            // 나만 나가기
            db.collection(FBFirestoreHelper.ROOM_PATH).document(self.roomsDocId ?? "")
                .collection(FBFirestoreHelper.MEMBER_PATH).document(uid).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
    
}
