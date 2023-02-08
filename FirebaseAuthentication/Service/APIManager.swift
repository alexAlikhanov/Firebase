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
    var UID: String? { get set }
    func getTasks(document: String, complition: @escaping ([Task]?) -> Void)
    func createTask(task: Task, complition: @escaping (Result<String?, Error>) -> Void)
    func createUser(userName: String, email: String, complition: @escaping () -> Void)
    func updateTask(task: Task, complition: @escaping (Result<String?, Error>) -> Void)
    func login(withEmail email: String, password: String, complition: @escaping (Result<String?, Error>) -> Void)
    func signIn(withEmail email: String, password: String, userName: String, complition: @escaping (Result<String?, Error>) -> Void)
    func logOut()
    func removeTask(documentId: String, complition: @escaping (Bool) -> Void)
}

class APIManager : APIManagerProtocol {
    
    static let shared = APIManager()
    var currentUser: AuthDataResult!
    public var UID: String?
    
   private func configureFB() -> Firestore {
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
                self.UID = result?.user.uid
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
                self.UID = result.user.uid
                self.createUser(userName: userName, email: email) {
                        complition(.success(result.user.uid))
                    }
                }
            }
        }
    
    func logOut() {
        
    }
    
    func getTasks(document: String, complition: @escaping ([Task]?) -> Void){
        let db = configureFB()
        var retTasks: [Task] = []
        db.collection("Users").document(self.UID!).collection("Tasks").getDocuments { data, error in
            
            if error != nil {
                complition(nil)
            } else {
                guard let tasks = data?.documents else { complition(nil); return }
                for task in tasks {
                    let t = Task(id: task.documentID, title: task.get("title") as! String, subtitle: task.get("subtitle") as! String, body: task.get("body") as! String)
                    retTasks.append(t)
                }
                complition(retTasks)
            }
        }
    }
    
    func createTask(task: Task, complition: @escaping (Result<String?, Error>) -> Void) {
        let db = configureFB()
        var ref : DocumentReference? = nil
        ref = db.collection("Users").document(self.UID!).collection("Tasks").addDocument(data: ["title":task.title, "subtitle":task.subtitle, "body": task.body]) { error in
            if error != nil {
                complition(.failure(error!))
            } else {
                complition(.success(ref!.documentID))
            }
        }
    }
    
    func updateTask(task: Task, complition: @escaping (Result<String?, Error>) -> Void) {
        let db = configureFB()
        db.collection("Users").document(self.UID!).collection("Tasks").document(task.id).updateData(["title":task.title, "subtitle":task.subtitle, "body": task.body]) { error in
            if error != nil {
                complition(.failure(error!))
            } else {
                complition(.success(""))
            }
        }
    }
    
    func createUser(userName: String, email: String, complition: @escaping () -> Void){
        let db = configureFB()
        db.collection("Users").document(self.UID!).setData([
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
    
    func removeTask(documentId: String, complition: @escaping (Bool) -> Void) {
        let db = configureFB()
        db.collection("Users").document(self.UID!).collection("Tasks").document(documentId).delete { error in
            if error != nil {
                complition(false)
            } else {
                complition(true)
            }
        }
    }

}
