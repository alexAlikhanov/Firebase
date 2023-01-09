//
//  MainViewController2.swift
//  FirebaseAuthentication
//
//  Created by Алексей on 12/26/22.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func updateTableViewData()
}

class MainViewController2: UIViewController {
    
    public var presenter: MainViewPresenterProtocol?
    private var taskTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tasks"
        let addButt = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonAction(sender:)))
        let editButt = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonAction(sender:)))
        self.navigationItem.rightBarButtonItems = [addButt, editButt]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .done, target: self, action: #selector(logoutBarButtonAction(sender:)))
        createTaskTableView()
        presenter?.mainViewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createConstraints()
        presenter?.mainViewLoaded()
    }
    
    private func createTaskTableView(){
        taskTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        taskTableView.register(TaskCell.self, forCellReuseIdentifier: "Cell")
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.separatorStyle = .none
        taskTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        taskTableView.tag = 0
        view.addSubview(taskTableView)
    }
    
    private func createConstraints(){
        
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            taskTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    func addBarButtonAction(sender: UIBarButtonItem){
        presenter?.createTask()
    }
    @objc
    func editBarButtonAction(sender: UIBarButtonItem){
        
    }
    @objc
    func logoutBarButtonAction(sender: UIBarButtonItem){
        presenter?.logOut()
    }
}
extension MainViewController2: MainViewProtocol {
    func updateTableViewData() {
        taskTableView.reloadData()
    }
}
extension MainViewController2: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.tasks?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TaskCell else { return UITableViewCell() }
        guard let task = presenter?.tasks?[indexPath.row] else { return cell }
        cell.setupCell(title: task.title, subtitle: task.subtitle)
        cell.accessoryType  = .disclosureIndicator
        return cell
    }
    
    
}
