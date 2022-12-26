//
//  APIManager.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/23/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseCoreInternal

class APIManager {
    
    static let shared = APIManager()
    var currentUser: AuthDataResult!
    
    func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings.init()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(collection: String, document: String, complition: @escaping (Document?) -> Void){
        let db = configureFB()
        db.collection(collection).document(document).getDocument { (document, error) in
            guard error != nil else { complition(nil); return }
            let doc = Document(field1: document?.get("field1") as! String, field2: document?.get("field2")as! String)
            complition(doc)
        }
    }
    
    func createUser(uid: String, userName: String, email: String, complition: @escaping () -> Void){
        let db = configureFB()
        db.collection("Users").document(uid).setData([
            "userName": userName,
            "email": email
        ]) { error in
            if let error = error {
                print("error \(error.localizedDescription)")
            } else {
                complition()
            }
        }
    }
    
    func setPost(collection: String, document: String, complition: @escaping () -> Void){
        let db = configureFB()
        var ref : DocumentReference? = nil
        ref = db.collection(collection).addDocument(data: [document : document]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                complition()
            }
        }
    }

}
