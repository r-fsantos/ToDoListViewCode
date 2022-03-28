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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Antes de animações, antes da View ser chamada e ficar visível!
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
        tarefas = Service.shared.getData()
    }
    
    // MARK: NewTaskSelection
    @objc func callNewTaskView() {
        _ = TarefaDataSource.tarefas.map { Service.shared.save(task: $0) { print($0) } }
        
        let newTaskViewController = NewTaskViewController()
        
        newTaskViewController.modalPresentationStyle = .fullScreen
        present(newTaskViewController, animated: true) {
            print("ok!")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Cliquei na tela no índice \(indexPath.row)")

            let tarefa = tarefas[indexPath.row]

            changeTarefaStatus(task: tarefa)
            //            tarefas.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: "Deletar") { [weak self] (_, _, completion) in
            let tarefa = self?.tarefas[indexPath.row]
            self?.handleMoveToTrash(uuid: tarefa!.id, indexPath: indexPath)
            completion(true)
        }
        trash.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
    
    private func handleMoveToTrash(uuid: UUID, indexPath: IndexPath) {
        Service.shared.delete(taskUUID: uuid.description) { print($0) }
        DispatchQueue.main.async {
            print("entrei")
            self.tableView.deleteRows(at: [indexPath], with: .right)
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tarefa = tarefas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
            else {
                cell.accessoryType = .checkmark
            }
            changeTarefaStatus(task: tarefa)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        
        return cell
    }
}
