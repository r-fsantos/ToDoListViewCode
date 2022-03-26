//
//  NewTaskViewController.swift
//  ToDoListViewCode
//
//  Created by Renato F. dos Santos Jr on 26/03/22.
//
import UIKit

class NewTaskViewController: UIViewController {

    var safeArea: UILayoutGuide!

    lazy var buttonLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.tintColor = .black
        button.layer.backgroundColor = UIColor.systemGray5.cgColor
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.tapSalvar(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var inputTitleLabel: UITextField = {
        let inputText = UITextField()
        inputText.layer.borderWidth = 1
        inputText.layer.borderColor = UIColor.systemGray5.cgColor
        inputText.textColor = .black
        inputText.placeholder = "Titulo"
        inputText.textAlignment = .center
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.font = UIFont.systemFont(ofSize: 25)
        inputText.layer.cornerRadius = 5
        return inputText
    }()

    lazy var inputDetailLabel: UITextField = {
        let inputText = UITextField()
        inputText.textColor = .black
        inputText.placeholder = "Descrição da tarefa"
        inputText.textAlignment = .center
        inputText.layer.borderWidth = 1
        inputText.layer.borderColor = UIColor.systemGray5.cgColor
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.font = UIFont.systemFont(ofSize: 25)
        inputText.layer.cornerRadius = 5
        return inputText
    }()

    @objc func tapSalvar(sender:UIButton){
        dismiss(animated: true, completion: { print("Sucesso dismiss") })
    }

    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        title = "Task ADD"
        self.view.backgroundColor = .orange
        super.viewDidLoad()
        self.view.addSubview(self.inputTitleLabel)
        self.view.addSubview(self.inputDetailLabel)
        self.view.addSubview(self.buttonLabel)
        configConstraints()
    }

    private func configConstraints(){
        // TODO: Create Metrics file
        NSLayoutConstraint.activate([
            self.inputTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.inputTitleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.inputTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.inputTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            self.inputDetailLabel.topAnchor.constraint(equalTo: self.inputTitleLabel.bottomAnchor, constant: 10),
            self.inputDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.inputDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            self.buttonLabel.topAnchor.constraint(equalTo: self.inputDetailLabel.bottomAnchor, constant: 50),
            self.buttonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.buttonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

}
