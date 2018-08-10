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
    let roomRootPath = "rooms"
    
    //생성된 방 번호
    var documentID : String? = nil
    
    @IBAction func clickCreate(_ sender: Any) {
        createRoom()
    }
    
    //방 생성 함수
    func createRoom(){
        if let user = FBAuthenticationHelper.sharedInstance.getCurrentUser() {
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection(roomRootPath).addDocument(data: ["owner":user.uid]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
                    self.documentID = ref?.documentID ?? nil
                }
            }
            
        }
    }
    
    @IBAction func clickJoin(_ sender: Any) {
        performSegue(withIdentifier: "segueReadyToPlay", sender: nil)
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
            vc.code = codeTextField.text
            vc.roomUid = documentID
        }
    }
}
