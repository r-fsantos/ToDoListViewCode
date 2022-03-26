//
//  ViewController.swift
//  ToDoListViewCode
//
//  Created by Renato F. dos Santos Jr on 26/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Lazy vars
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false

        // TODO: Register cell
        return table
    }()
    
    lazy var tarefas = [TarefaData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tarefas"
        view.addSubview(tableView)

        // TODO: Create a metrics file
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        // GetTasks
        tarefas = Service.shared.getData()
        print(tarefas)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true

        // TODO: Do we need some appearence configs?

        let newTaskButton = UIBarButtonItem(image: UIImage.init(systemName: "plus"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(callNewTaskView))
        // TODO: Erase? TouchUpInside -> alert ...
        // navigationController?.editButtonItem =

        navigationItem.rightBarButtonItem = newTaskButton

        // GetTasks
    }

    // MARK: NewTaskSelection
    /// Transition to create new task
    @objc func callNewTaskView() {
//        _ = TarefaDataSource.tarefas.map { Service.shared.save(task: $0) { print($0) } }
    }

}

// MARK: Extensions
/// TODO: Separate into a separeted folder/file
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cliquei na tela no índice \(indexPath.row)")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
