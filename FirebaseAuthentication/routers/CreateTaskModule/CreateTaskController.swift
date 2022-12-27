//
//  CreateTaskController.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/27/22.
//

import UIKit

protocol CreateTaskProtocol: AnyObject {
    var presenter: CreateTaskPresenterProtocol? { get set }
}


class CreateTaskController: UIViewController, CreateTaskProtocol {
   public var presenter: CreateTaskPresenterProtocol?
    
    private let titleTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Заголовок"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let subTitleTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Краткое описание"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Create task"
        view.addSubview(titleTextField)
        view.addSubview(subTitleTextField)
        
        let saveButt = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonAction(sender:)))
        self.navigationItem.rightBarButtonItems = [saveButt]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonAction(sender:)))

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createConstraints()
    }
    
    func createConstraints(){
        NSLayoutConstraint.activate([
            titleTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 9/10),
            titleTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
        NSLayoutConstraint.activate([
            subTitleTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 9/10),
            subTitleTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            subTitleTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20)
        ])
    }
    
    @objc
    func saveBarButtonAction(sender:UIBarButtonItem) {
        if titleTextField.text != "", subTitleTextField.text != "" {
            presenter?.save(title: titleTextField.text! , subtitle: subTitleTextField.text!)
        }
    }
    
    @objc
    func cancelBarButtonAction(sender:UIBarButtonItem) {
        presenter?.cancel()
    }

}


