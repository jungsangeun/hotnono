//
//  PlayViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 9..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import FirebaseFirestore
class PlayViewController: BaseViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var quitButton: MDCButton!
    @IBOutlet weak var leftButton: MDCButton!
    @IBOutlet weak var topButton: MDCButton!
    @IBOutlet weak var rightButton: MDCButton!
    @IBOutlet weak var bottomButton: MDCButton!
    
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
    @IBAction func clickQuit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickLeft(_ sender: Any) {
        
    }
    
    @IBAction func clickTop(_ sender: Any) {
        
    }
    
    @IBAction func clickRight(_ sender: Any) {
        
    }
    
    @IBAction func clickBottom(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        MaterialDesignUtil.applyButtonTheme(quitButton)
        MaterialDesignUtil.applyButtonTheme(leftButton)
        MaterialDesignUtil.applyButtonTheme(topButton)
        MaterialDesignUtil.applyButtonTheme(rightButton)
        MaterialDesignUtil.applyButtonTheme(bottomButton)
        
        //현재 방 변화 모니터링
        startDBMonitoring()
        
        //Test Code
        if let user = FBAuthenticationHelper.sharedInstance.getCurrentUser() {
            let memberInfo : RoomMemberInfo = RoomMemberInfo(uid: user.uid)
            memberInfo.positionX = 1
            memberInfo.positionY = 1
            memberInfo.name = "Test"
            uploadMemberInfo(memberInfo: memberInfo)
        }
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
        guard let uid = roomUid else {
            print("Uid is nil")
            return
        }
        
        let db = Firestore.firestore()
        //방 정보 모니터링
        roomMonitoringSubscribe = db.collection(roomRootPath).document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                //변경된 방 정보 출력
                print(document.data())
        }
    
        //방 멤버 정보 변경 모니터링
        roomMemberMonitoringSubscribe = db.collection(roomRootPath).document(uid).collection(memberPath)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                //변경된 멤버 정보 출력
                for document in document.documents{
                    print(document.data())
                }
        }
    }
    
    //방 모니터링 중단
    func stopDBMonitoring(){
        guard let roomSubscribe = roomMonitoringSubscribe else {return}
        subscribe.remove()
        guard let roomMembersubscribe = roomMemberMonitoringSubscribe else {return}
        roomMembersubscribe.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Room Uid 체크
        guard let uid = roomUid else {
            print("uid is nil")
            return
        }
        
        //라벨 설정
        codeLabel.text = String(format:"Room ID : %@",uid)
    }
}
