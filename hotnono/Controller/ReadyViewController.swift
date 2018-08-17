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
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var joinButton: MDCButton!
    @IBOutlet weak var backToSignInButton: MDCButton!
    
    //생성된 방 번호
    var documentID : String? = nil
    
    /**
     방 생성 함수
     방 생성에 성공하면 게임 플레이 창으로 이동한다
     **/
    func tryCreateRoomAndPlay(_ roomId: String){
        guard let uid = FBAuthenticationHelper.sharedInstance.getCurrentUser()?.uid else {
            showAlertPopup(message: "로그인 정보를 다시 확인해주세요")
            return
        }
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomId)
        roomRef.setData(["owner" : uid])
        self.documentID = roomId
        // 생성된 방으로 이동
        self.performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
    }
    
    @IBAction func clickJoin(_ sender: Any) {
        guard let roomId = codeTextField.text else {
            showAlertPopup(message: "방 번호를 입력하세요")
            return
        }
        
        let db = Firestore.firestore()
        let roomRef = db.collection(FBFirestoreHelper.ROOM_PATH).document(roomId)
        roomRef.getDocument {
            document, error in
            if let document = document, document.exists {
                print(document)
            } else {
                self.tryCreateRoomAndPlay(roomId)
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
            vc.roomUid = documentID
        }
    }
}
