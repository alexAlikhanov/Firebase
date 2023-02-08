//
//  DetailTaskController.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 1/9/23.
//

import UIKit

protocol DetailTaskProtocol: AnyObject {
    var presenter: DetailTaskPresenterProtocol? { get set }
    func setup(task: Task)
    func feedback(isSave: Bool)
}

class DetailTaskController: UIViewController, DetailTaskProtocol {
    public var presenter: DetailTaskPresenterProtocol?
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 30)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textView)
        let saveButt = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonAction(sender:)))
        self.navigationItem.rightBarButtonItems = [saveButt]
        presenter?.viewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createConstraints()
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            textView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    @objc func saveBarButtonAction(sender: UIBarButtonItem){
        guard let text = textView.text else { return }
        presenter?.save(bodyText: text)
    }
    
    func setup(task: Task) {
        navigationItem.title = task.title
        textView.text = task.body
    }
    
    func feedback(isSave: Bool) {
        if isSave {
            self.navigationItem.rightBarButtonItems?.first?.isEnabled = false
        } else {
            Util.shared.showAlert(withTitile: "Oops", massage: "ошибка созранения файла", viewController: self, complition: nil)
        }
    }


}
