//
//  ReadyViewController.swift
//  hotnono
//
//  Created by jungsangeun on 2018. 8. 8..
//  Copyright © 2018년 jungsangeun. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import FirebaseFirestore
class ReadyViewController: BaseViewController {
    
    @IBOutlet weak var createButton: MDCButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var joinButton: MDCButton!
    @IBOutlet weak var backToSignInButton: MDCButton!
    
    //Firebase Database Room 목록이 있는 경로
    //TODO : 상수 관리 방식 적용
    let roomRootPath = "rooms"
    
    //생성된 방 번호
    var documentID : String? = nil
    
    @IBAction func clickCreate(_ sender: Any) {
        tryCreateRoomAndPlay()
    }
    
    /**
     방 생성 함수
     방 생성에 성공하면 게임 플레이 창으로 이동한다
     **/
    func tryCreateRoomAndPlay(){
        if let user = FBAuthenticationHelper.sharedInstance.getCurrentUser() {
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection(roomRootPath).addDocument(data: ["owner":user.uid]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    // TODO : 방 생성 실패 팝업 표시
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.documentID = ref?.documentID ?? nil
                    // 생성된 방으로 이동
                    self.performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
                }
            }
        }
    }
    
    @IBAction func clickJoin(_ sender: Any) {
        performSegue(withIdentifier: "segueReadyToPlay", sender: sender)
    }
    
    @IBAction func clickQuit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MaterialDesignUtil.applyButtonTheme(createButton)
        MaterialDesignUtil.applyButtonTheme(joinButton)
        MaterialDesignUtil.applyButtonTheme(backToSignInButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReadyToPlay" {
            let vc = segue.destination as! PlayViewController
            
            //TODO : sender 이외에 다른 방식으로 체크할 플래그를 전달할수 있는지 확인
            vc.roomUid = sender != nil ? codeTextField.text : documentID
        }
    }
}
