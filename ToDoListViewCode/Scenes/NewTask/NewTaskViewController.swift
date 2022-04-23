import UIKit

// MARK: Avoid half portuguese and english would recommend choose one
class NewTaskViewController: UIViewController {
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.onTapCloseButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = AppTheme.buildButton(with: .system,
                                          title: "Salvar",
                                          fontSize: 25,
                                          fontColor: .black)
        
        button.addTarget(self, action: #selector(onTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    
    lazy var inputTitleLabel: UITextField = {
        AppTheme.buildTextField(placeholder: "Título",
                                fontColor: .black, fontSize: 25)
    }()
    
    lazy var inputDetailLabel: UITextField = {
        AppTheme.buildTextField(placeholder: "Descrição da tarefa",
                                fontColor: .black,
                                fontSize: 25)
    }()
    
    @objc func onTapSaveButton(sender: UIButton) {
        guard inputTitleLabel.hasText,
              inputDetailLabel.hasText,
              let title = inputTitleLabel.text,
              let detail = inputDetailLabel.text else {
                  let allertEmptyTarefa = UIAlertController(title: "ERRO", message: "Digite título e descrição!", preferredStyle: .alert)
                  allertEmptyTarefa.addAction(UIAlertAction(title: "Tentar novamente", style: .destructive, handler: nil))
                  present(allertEmptyTarefa, animated: true, completion: nil)
                  return
              }
        
        let tarefa = TarefaData.init(id: UUID(),
                                     title: title,
                                     detail: detail,
                                     isDone: false)
        
        Service.shared.save(task: tarefa) { print($0) }
        
        dismiss(animated: true, completion: {
            print("Tarefa criada com sucesso: \(tarefa)")
        })
    }

    @objc func onTapCloseButton(sender: UIButton) {
        dismiss(animated: true, completion: {
            print("tapFechar")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewConfiguration()
        setUpConstraints()
    }
    
    private func setUpViewConfiguration() {
        title = "Nova Tarefa"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .lightGray
        view.addSubview(inputTitleLabel)
        view.addSubview(inputDetailLabel)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            inputTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            inputTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputDetailLabel.topAnchor.constraint(equalTo: inputTitleLabel.bottomAnchor, constant: 16),
            inputDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: inputDetailLabel.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: inputTitleLabel.topAnchor, constant: -22),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}
