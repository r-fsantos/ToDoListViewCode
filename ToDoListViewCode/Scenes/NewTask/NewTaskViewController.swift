import UIKit

// MARK: Avoid half portuguese and english would recommend choose one
class NewTaskViewController: UIViewController {
    //    var safeArea: UILayoutGuide!
    
    // todo: Don't
    lazy var buttonLabelFechar: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.tapFechar(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonLabel: UIButton = {
        let button = AppTheme.buildButton(with: .system,
                                          title: "Salvar",
                                          fontSize: 25,
                                          fontColor: .black)
        
        button.addTarget(self, action: #selector(tapSalvar), for: .touchUpInside)
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
    
    @objc func tapSalvar(sender: UIButton) {
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

    @objc func tapFechar(sender: UIButton) {
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
        title = "Task ADD"
        view.backgroundColor = .white
        view.addSubview(inputTitleLabel)
        view.addSubview(inputDetailLabel)
        view.addSubview(buttonLabelFechar)
        view.addSubview(buttonLabel)
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
            inputDetailLabel.heightAnchor.constraint(equalToConstant: 70),
            buttonLabel.topAnchor.constraint(equalTo: inputDetailLabel.bottomAnchor, constant: 16),
            buttonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonLabelFechar.bottomAnchor.constraint(equalTo: inputTitleLabel.topAnchor, constant: -22),
            buttonLabelFechar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            buttonLabelFechar.heightAnchor.constraint(equalToConstant: 30),
            buttonLabelFechar.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}
