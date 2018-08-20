//
//  ReadyViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 8..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import FirebaseAuth
import FirebaseFirestore

class ReadyViewController: BaseViewController {
    
    //생성된 방 번호
    var roomDocument: RoomDocument?
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var joinButton: MDCButton!
    @IBOutlet weak var backToSignInButton: MDCButton!
    
    @IBAction func clickJoin(_ sender: Any) {
        guard let user = FBAuthenticationHelper.sharedInstance.getCurrentUser() else {
            showAlertPopup(message: "로그인 정보를 다시 확인해주세요")
            return
        }
        
        guard let roomsDocId = codeTextField.text else {
            showAlertPopup(message: "방 번호를 입력하세요")
            return
        }
        
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId)
        roomRef.getDocument {
            document, error in
            if let document = document, document.exists {
                self.roomDocument = RoomDocument(id: roomsDocId, data: document.data())
                self.joinRoom(user: user)
            } else {
                self.roomDocument = RoomDocument(id: roomsDocId, owner: user.uid)
                self.tryCreateRoomAndPlay(user: user)
            }
        }
    }
    
    @IBAction func clickQuit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MaterialDesignUtil.applyButtonTheme(joinButton)
        MaterialDesignUtil.applyButtonTheme(backToSignInButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReadyToPlay" {
            let vc = segue.destination as! PlayViewController
            
            //TODO : sender 이외에 다른 방식으로 체크할 플래그를 전달할수 있는지 확인
            vc.roomsDocId = roomDocument?.id ?? ""
        }
    }
    
    /**
     방 생성 함수
     방 생성에 성공하면 게임 플레이 창으로 이동한다
     **/
    func tryCreateRoomAndPlay(user: User) {
        guard let roomsDocId = roomDocument?.id else {
            print("Empty roomDocId")
            return
        }
        
        // Owner ID 추가
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId)
        roomRef.setData(roomDocument?.toData() ?? [:])
        
        addMemberData(roomRef, user: user)
        moveToRoom()
    }
    
    func joinRoom(user: User) {
        guard let status = roomDocument?.status, status == .Idle else {
            showAlertPopup(message: "이미 게임이 진행 중입니다 :(")
            return
        }
        
        guard let roomsDocId = roomDocument?.id else {
            print("Empty roomDocId")
            return
        }
        
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomsDocId)
        let memberRef = roomRef.collection(FBFirestoreHelper.MEMBER_PATH)
        memberRef.getDocuments {
            documentSnapshot, error in
            
            guard let document = documentSnapshot else {
                self.showAlertPopup(message: "Error fetching document: \(error!)")
                return
            }
            
            var isJoined = false
            let documents = document.documents
            for doc in documents {
                let member = RoomMemberInfo(doc.data())
                if let uid = member.uid, uid == user.uid {
                    isJoined = true
                }
            }
            
            if (isJoined) {
                self.moveToRoom()
            } else if document.documents.count >= PlayModel.MAX_COUNT {
                self.showAlertPopup(message: "최대 인원을 초과했어요.\n잠시 후 다시 이용해주세요 :(")
            } else {
                self.addMemberData(roomRef, user: user)
                self.moveToRoom()
            }
        }
    }
    
    func addMemberData(_ roomRef: DocumentReference, user: User) {
        // Member 정보 추가
        let memberInfo : RoomMemberInfo = RoomMemberInfo(uid: user.uid)
        memberInfo.initX = 0
        memberInfo.initY = 0
        memberInfo.positionX = 0
        memberInfo.positionY = 0
        memberInfo.status = RoomMemberInfo.Status.Idle
        memberInfo.name = user.displayName ?? "noname"
        roomRef.collection(FBFirestoreHelper.MEMBER_PATH).document(user.uid).setData(memberInfo.toData())
    }
    
    func moveToRoom() {
        // 생성된 방으로 이동
        self.performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
    }
}
