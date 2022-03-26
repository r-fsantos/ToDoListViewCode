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
    
    lazy var tarefas = [TarefaData]() { didSet { tarefasFiltradas = filterTasks(tasks: tarefas) } }
    
    lazy var tarefasFiltradas = [[TarefaData]]() {
        didSet { DispatchQueue.main.async { self.tableView.reloadData() } }
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
//        _ = TarefaDataSource.tarefas.map { Service.shared.save(task: $0) { print($0) } }

        let newTaskViewController = NewTaskViewController()

        newTaskViewController.modalPresentationStyle = .fullScreen
        present(newTaskViewController, animated: true) {
            print("ok!")
        }
        tableView.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cliquei na tela no índice \(indexPath.row)")
        
        let section = tarefasFiltradas[indexPath.section]
        let tarefa = section[indexPath.row]
        
        changeTarefaStatus(task: tarefa)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        
        for item in self.tarefasFiltradas {
            if item.count > 0 {
                count += 1
            }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /**
            ? Possible Implementation.
            switch sectIon {
                case .Done:
                    return .Done.rawValue
                case .ToBeDone:
                    return .ToBeDone.rawValue
                case .NoTasks:
                    return .NoTasks.raw_value
            }
         */
        if section == 1 {
            return "Concluídas"
        } else {
            return "A Fazer"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.tarefasFiltradas[section]
        
        return section.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = tarefasFiltradas[indexPath.section]
        let tarefa = section[indexPath.row]
        
        // Configure cell here based on "tarefa" info
//        let cell =
//        cell.backgroundColor = (tarefa.isDone) ? .green : .red
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TarefaTableViewCell.identifier, for: indexPath) as? TarefaTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = tarefa.title
        cell.descritionLabel.text = tarefa.detail
        
        return cell
    }
}

extension HomeViewController {
    func filterTasks(tasks: [TarefaData]) -> [[TarefaData]] {
        var filteredTasks: [[TarefaData]] = []
        var toBeDoneTasks: [TarefaData] = []
        var doneTasks: [TarefaData] = []
        
        for item in tasks {
            if item.isDone {
                doneTasks.append(item)
            } else {
                toBeDoneTasks.append(item)
            }
        }
        
        filteredTasks.append(toBeDoneTasks)
        filteredTasks.append(doneTasks)
        
        return filteredTasks
    }
}
