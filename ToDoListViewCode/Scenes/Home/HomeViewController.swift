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
        table.register(TarefaTableViewCell.self, forCellReuseIdentifier: TarefaTableViewCell.identifier)
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
        setUpViewConfiguration()
        tarefas = Service.shared.getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let newTaskButton = UIBarButtonItem(image: UIImage.init(systemName: "plus"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(callNewTaskView))
        navigationItem.rightBarButtonItem = newTaskButton
        tarefas = Service.shared.getData()
    }
    
    private func setUpViewConfiguration() {
        title = "Tarefas"
        view.addSubview(tableView)
        
        // TODO: Create a metrics file
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    // MARK: NewTaskSelection
    @objc func callNewTaskView() {

        let newTaskViewController = NewTaskViewController()
        
        newTaskViewController.modalPresentationStyle = .fullScreen
        
        present(newTaskViewController, animated: true) {
            print("ok!")
        }
        tarefas = Service.shared.getData()
    }
    
    // MARK: - Change Tarefa
    func changeTarefaStatus(task: TarefaData) {
        var targetTask = task
        targetTask.isDone = !task.isDone
        
        Service.shared.update(task: targetTask) { result in
            print(result)
            
            if (result == "Successful Update") {
                self.tarefas = Service.shared.getData()
            }
        }
    }
}

// MARK: Extensions
/// TODO: Separate into a separeted folder/file
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: "Deletar") { [weak self] (_, _, completion) in
            let tarefa = self?.tarefas[indexPath.row]
            self?.handleMoveToTrash(uuid: tarefa!.id)
            completion(true)
        }
        trash.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
    
    private func handleMoveToTrash(uuid: UUID) {
        Service.shared.delete(taskUUID: uuid.description) { print($0) }
        tarefas = tarefas.filter { !($0.id == uuid) }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tarefa = tarefas[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
            changeTarefaStatus(task: tarefa)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tarefas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TarefaTableViewCell.identifier,
                                                       for: indexPath) as? TarefaTableViewCell else { return UITableViewCell() }
        let tarefa = tarefas[indexPath.row]
        cell.titleLabel.text = tarefa.title
        cell.descritionLabel.text = tarefa.detail
        cell.accessoryType = tarefa.isDone ? .checkmark : .none
        return cell
    }
}
