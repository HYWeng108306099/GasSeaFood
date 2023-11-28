
import UIKit


class LaunchViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupAllSubView()
        
        CityCenter.share.start()
    }
    
    func setupAllSubView() {
        
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 35
        
        stackView.addArrangedSubview(self.createTitleLabel())
        stackView.addArrangedSubview(self.createCommandButton(title: "登入", action: { self.gotoLogin() }))
        stackView.addArrangedSubview(self.createCommandButton(title: "註冊", action: { self.gotoRegis() }))
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
        
        
        
    }
    
    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "師傅管理系統"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
        
        return titleLabel
    }
    
    func createCommandButton(title: String, action: (()->())?) -> UIButton {
        let button = ActionButton(action: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(hex: "3472D9")
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        
        return button
    }
    
    func gotoLogin() {
        
        let vc = UINavigationController(rootViewController: LoginViewController())
        
        self.present(vc, animated: true)
        
    }
    
    func gotoRegis() {
        let vc = UINavigationController()
        let child2 = RegisViewController()
        child2.navigationItem.backBarButtonItem = UIBarButtonItem()
        vc.viewControllers = [child2]
        self.present(vc, animated: true)
    }
    
    
}

