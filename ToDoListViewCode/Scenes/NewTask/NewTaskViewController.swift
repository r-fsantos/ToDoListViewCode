//
//  NewTaskViewController.swift
//  ToDoListViewCode
//
//  Created by Renato F. dos Santos Jr on 26/03/22.
//

import UIKit

class NewTaskViewController: UIViewController {
    var safeArea: UILayoutGuide!
    
    lazy var buttonLabelFechar: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.tapFechar(sender:)), for: .touchUpInside)
        return button
    }()
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
           inputText.adjustsFontSizeToFitWidth = true
           return inputText
       }()
    
    @objc func tapSalvar(sender:UIButton){
            // TODO
//           print("Sucesso")
        dismiss(animated: true, completion: {
                    print("tapSalvar")
                    
                })

    }
    
    @objc func tapFechar(sender:UIButton){
            // TODO
//           print("Sucesso")
        dismiss(animated: true, completion: {
                    print("tapFechar")
                    
                })

    }
 
    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        title = "Task ADD"
        self.view.backgroundColor = .white
        super.viewDidLoad()
        self.view.addSubview(self.inputTitleLabel)
        self.view.addSubview(self.inputDetailLabel)
        self.view.addSubview(self.buttonLabelFechar)
        self.view.addSubview(self.buttonLabel)

        configConstraints()
        

    }
    
    
    private func configConstraints(){
        
        NSLayoutConstraint.activate([
            self.inputTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 55),
             self.inputTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
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
        
        NSLayoutConstraint.activate([
            self.buttonLabelFechar.bottomAnchor.constraint(equalTo: self.inputTitleLabel.topAnchor, constant: -22),
                   self.buttonLabelFechar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
                   self.buttonLabelFechar.heightAnchor.constraint(equalToConstant: 30),
                   self.buttonLabelFechar.widthAnchor.constraint(equalToConstant: 30)

                   
               ])
    }

}
