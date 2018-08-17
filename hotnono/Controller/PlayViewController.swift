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
    
    //현재 Room Uid
    var roomUid: String?
    
    //Firebase Database Room 목록이 있는 경로
    //TODO : 상수 관리 방식 적용
    let roomRootPath = "rooms"
    let memberPath = "members"
    
    //방 정보 모니터링 Subscribe
    var roomMonitoringSubscribe : ListenerRegistration? = nil
    
    //방 멤버 정보 모니터링 Subscribe
    var roomMemberMonitoringSubscribe : ListenerRegistration? = nil
    
    var user: User? = nil
    var playModel: PlayModel? = nil
    var compositeDisposable: CompositeDisposable = CompositeDisposable()
    
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickLeft(_ sender: Any) {
        guard let (x, y, status) = playModel?.getPosition(direction: .Left) else { return }
        self.addData(x: x, y: y, status: status)
    }
    
    @IBAction func clickTop(_ sender: Any) {
        guard let (x, y, status) = playModel?.getPosition(direction: .Top) else { return }
        self.addData(x: x, y: y, status: status)
    }
    
    @IBAction func clickRight(_ sender: Any) {
        guard let (x, y, status) = playModel?.getPosition(direction: .Right) else { return }
        self.addData(x: x, y: y, status: status)
    }
    
    @IBAction func clickBottom(_ sender: Any) {
        guard let (x, y, status) = playModel?.getPosition(direction: .Bottom) else { return }
        self.addData(x: x, y: y, status: status)
    }
    
    override func viewDidLoad() {
        MaterialDesignUtil.applyButtonTheme(quitButton)
        
        MaterialDesignUtil.applyButtonTheme(playButton)
        MaterialDesignUtil.applyButtonTheme(finishButton)
        MaterialDesignUtil.applyButtonTheme(resetButton)
        
        MaterialDesignUtil.applyButtonTheme(leftButton)
        MaterialDesignUtil.applyButtonTheme(topButton)
        MaterialDesignUtil.applyButtonTheme(rightButton)
        MaterialDesignUtil.applyButtonTheme(bottomButton)
        
        reset()
        
        user = FBAuthenticationHelper.sharedInstance.getCurrentUser()
        
        //현재 방 변화 모니터링
        startDBMonitoring()
        
        subscribeEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let roomId = roomUid else {
            print("uid is nil")
            showAlertPopup(message: "방 번호가 잘못 되었습니다 :(") {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        //라벨 설정
        codeLabel.text = String(format:"방번호 %@", roomId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        compositeDisposable.dispose()
        RxEvent.sharedInstance.clearAll()
    }
    
    func uploadMemberInfo(memberInfo:RoomMemberInfo){
        
        //Room Uid 체크
        guard let roomUid = roomUid else {
            print("Room Uid is nil")
            return
        }
        
        //Memeber Uid 체크
        guard let memberUid = memberInfo.uid else {
            print("Memeber Uid is nil")
            return
        }
        
        let db = Firestore.firestore()
        db.collection(roomRootPath).document(roomUid).collection(memberPath).document(memberUid).setData(memberInfo.toData())
    }
    
    //방 모니터링 시작
    func startDBMonitoring(){
        
        //Room Uid 체크
        guard let roomId = roomUid else {
            print("Uid is nil")
            return
        }
        
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomId)
        
         // 처음 멤버 정보 한번 가져와서 참여 가부 결정하기
        roomRef.getDocument {
            document, error in
            if let document = document, document.exists {
                let ownerId = document.get("owner") as! String
                
            } else {
                self.showAlertPopup(message: "방 정보를 못 가져왔어요 :(")
            }
        }
        
        // 처음 멤버 정보 한번 가져와서 참여 가부 결정하기
        roomRef.collection(FBFirestoreHelper.MEMBER_PATH).getDocuments {
            documentSnapshot, error in
            guard let document = documentSnapshot else {
                self.showAlertPopup(message: "Error fetching document: \(error!)")
                return
            }
            
            
            if self.playModel == nil {
                self.playModel = PlayModel(myId: self.user?.uid ?? "", ownerId: ownerId, documents: document.documents)
                
                self.reset()
                
                if ((self.playModel?.isJoinable()) != nil) {
                    //방 멤버 정보 변경 모니터링
                    self.roomMemberMonitoringSubscribe = db.collection(self.roomRootPath).document(uid).collection(self.memberPath)
                        .addSnapshotListener { documentSnapshot, error in
                            guard let document = documentSnapshot else {
                                print("Error fetching document: \(error!)")
                                return
                            }
                            
                            //변경된 멤버 정보 출력
                            for document in document.documents{
                                print(String(format: "updated member: %@", document.data()))
                                
                                let member = RoomMemberInfo(document.data())
                                if (self.playModel?.isJoined(member: member))! {
                                    // 사용자 업데이트
                                    let isCaught = self.playModel?.isCaught(member: member) ?? false
                                    self.playgroundView.movePlayer(id: member.uid ?? "", x: member.positionX, y: member.positionY, isCaught: isCaught)
                                    if isCaught {
                                        member.status = .Die
                                    }
                                } else {
                                    // 사용자 참여
                                    member.isTagger = ownerId == self.user?.uid
                                    member.isMe = self.user?.uid == member.uid
                                    self.playgroundView.joinPlayer(player: member)
                                }
                                self.playModel?.update(member: member)
                            }
                    }
                    let emptyPosition = self.playModel?.getEmptyPosition()
                    self.addData(x: emptyPosition?.x, y: emptyPosition?.y, status: RoomMemberInfo.Status.Live)
                } else {
                    self.showAlertPopup(message: "최대 인원을 초과했어요.\n잠시 후 다시 이용해주세요 :(") {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        
        
        
        
        //방 정보 모니터링
        roomMonitoringSubscribe = roomRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                //변경된 방 정보 출력
                print(String(format: "updated room: %@", document.data() ?? "nil"))
                
                // 처음 멤버 정보 한번 가져와서 참여 가부 결정하기
                let ownerId = document.data()?["owner"] as! String
                db.collection(FBFirestoreHelper.ROOM_PATH).document(roomId).collection(self.memberPath).getDocuments{ documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    if self.playModel == nil {
                        self.playModel = PlayModel(myId: self.user?.uid ?? "", ownerId: ownerId, documents: document.documents)
                        
                        self.reset()
                        
                        if ((self.playModel?.isJoinable()) != nil) {
                            //방 멤버 정보 변경 모니터링
                            self.roomMemberMonitoringSubscribe = db.collection(self.roomRootPath).document(uid).collection(self.memberPath)
                                .addSnapshotListener { documentSnapshot, error in
                                    guard let document = documentSnapshot else {
                                        print("Error fetching document: \(error!)")
                                        return
                                    }
                                    
                                    //변경된 멤버 정보 출력
                                    for document in document.documents{
                                        print(String(format: "updated member: %@", document.data()))
                                        
                                        let member = RoomMemberInfo(document.data())
                                        if (self.playModel?.isJoined(member: member))! {
                                            // 사용자 업데이트
                                            let isCaught = self.playModel?.isCaught(member: member) ?? false
                                            self.playgroundView.movePlayer(id: member.uid ?? "", x: member.positionX, y: member.positionY, isCaught: isCaught)
                                            if isCaught {
                                                member.status = .Die
                                            }
                                        } else {
                                            // 사용자 참여
                                            member.isTagger = ownerId == self.user?.uid
                                            member.isMe = self.user?.uid == member.uid
                                            self.playgroundView.joinPlayer(player: member)
                                        }
                                        self.playModel?.update(member: member)
                                    }
                            }
                            let emptyPosition = self.playModel?.getEmptyPosition()
                            self.addData(x: emptyPosition?.x, y: emptyPosition?.y, status: RoomMemberInfo.Status.Live)
                        } else {
                            self.showAlertPopup(message: "최대 인원을 초과했어요.\n잠시 후 다시 이용해주세요 :(") {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
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
    
    private func addData(x: Int?, y: Int?, status: RoomMemberInfo.Status) {
        if let user = user {
            let memberInfo : RoomMemberInfo = RoomMemberInfo(uid: user.uid)
            memberInfo.positionX = x ?? 0
            memberInfo.positionY = y ?? 0
            memberInfo.status = status
            memberInfo.name = user.displayName ?? "noname"
            uploadMemberInfo(memberInfo: memberInfo)
        }
    }
    
    private func start() {
        playgroundView.start()
        playButton.isEnabled = false
        finishButton.isEnabled = true
    }
    
    private func stop() {
        playgroundView.stop()
        finishButton.isEnabled = false
        resetButton.isEnabled = true
    }
    
    private func reset() {
        playgroundView.reset()
        
        if (user?.uid == playModel?.ownerId) {
            playButton.isEnabled = true
        } else {
            playButton.isEnabled = false
        }
        
        finishButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    private func subscribeEvent() {
//        let _ = compositeDisposable.insert(RxEvent.sharedInstance.getEvent(event: .JoinedPlayer, initValue: RoomMemberInfo())
//            .subscribe{ (event) in
//                guard let _ = event.element, event.element is RoomMemberInfo else {
//                    return
//                }
//                // 사용자 참여
//                let member = event.element as! RoomMemberInfo
//                let player = Player(member)
//                self.playgroundView.joinPlayer(player: player)
//        })
//
//        let _ = compositeDisposable.insert(RxEvent.sharedInstance.getEvent(event: .UpdatedPlayer, initValue: RoomMemberInfo())
//            .subscribe{ (event) in
//                guard let _ = event.element, event.element is RoomMemberInfo else {
//                    return
//                }
//                // 사용자 정보 변경
//                let member = event.element as! RoomMemberInfo
//                self.playgroundView.movePlayer(id: member.uid ?? "", x: member.positionX, y: member.positionY)
//        })
        let _ = compositeDisposable.insert(RxEvent.sharedInstance.getEvent(event: .CatchAllPlayer, initValue: false)
            .subscribe{ (event) in
                guard let catchAll = event.element, event.element is Bool else {
                    return
                }
                
                if catchAll as! Bool {
                    self.showAlertPopup(message: "다 잡았다!! :)") {
                        self.reset()
                    }
                }
        })
    }
}
