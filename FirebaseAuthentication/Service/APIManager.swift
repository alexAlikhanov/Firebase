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

protocol APIManagerProtocol{
    func configureFB() -> Firestore
    func getTasks(forUser uid: String, document: String, complition: @escaping ([Task]?) -> Void)
    func createTask(forUser uid: String, task: Task, complition: @escaping (Result<String?, Error>) -> Void)
    func createUser(uid: String, userName: String, email: String, complition: @escaping () -> Void)
    func setPost(collection: String, document: String, complition: @escaping () -> Void)
    func login(withEmail email: String, password: String, complition: @escaping (Result<String?, Error>) -> Void)
    func signIn(withEmail email: String, password: String, userName: String, complition: @escaping (Result<String?, Error>) -> Void)
    func logOut()
}

class APIManager : APIManagerProtocol {
    
    static let shared = APIManager()
    var currentUser: AuthDataResult!
    
    func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings.init()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func login(withEmail email: String, password: String, complition: @escaping (Result<String?, Error>) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                complition(.failure(error!))
            } else {
                APIManager.shared.currentUser = result
                complition(.success(result?.user.uid))
                }
            }
        }
    func signIn(withEmail email: String, password: String, userName: String, complition: @escaping (Result<String?, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { resault, error in
            if error != nil {
                complition(.failure(error!))
            } else {
                guard let result = resault else { return }
                self.createUser(uid: result.user.uid, userName: userName, email: email) {
                        complition(.success(result.user.uid))
                    }
                }
            }
        }
    
    func logOut() {
        
    }
    
    func getTasks(forUser uid: String, document: String, complition: @escaping ([Task]?) -> Void){
        let db = configureFB()
        var retTasks: [Task] = []
        db.collection("Users").document(uid).collection("Tasks").getDocuments { data, error in
            
            if error != nil {
                complition(nil)
            } else {
                guard let tasks = data?.documents else { complition(nil); return }
                for task in tasks {
                    let t = Task(title: task.get("title") as! String, subtitle: task.get("subtitle") as! String)
                    retTasks.append(t)
                }
                complition(retTasks)
            }
        }
    }
    
    func createTask(forUser uid: String, task: Task, complition: @escaping (Result<String?, Error>) -> Void) {
        let db = configureFB()
        var ref : DocumentReference? = nil
        ref = db.collection("Users").document(uid).collection("Tasks").addDocument(data: ["title":task.title, "subtitle":task.subtitle]) { error in
            if error != nil {
                complition(.failure(error!))
            } else {
                complition(.success(ref!.documentID))
            }
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
