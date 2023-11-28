
import Foundation
import UIKit

class CustomAlertController: UIViewController {
    
    convenience init(
        title: String?,
        content: String?,
        imageName: String?,
        buttonTitle: String?,
        dismissAction: (()->())? = nil
    ) {
        self.init()
        self.button = self.createButton(title: buttonTitle ?? "")
        self.titleLabel = self.createTitleLabel(text: title ?? "")
        self.stackView = self.createStackView(imageName: imageName ?? "", content: content ?? "")
        self.insideView = self.createInsideView()
        self.dismissAction = dismissAction
    }

    var button: UIButton = .init()
    
    var titleLabel: UILabel = .init()
    
    var stackView: UIStackView = .init()
    
    var insideView: UIView = .init()
    
    var dismissAction: (()->())?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAllSubView()
        
        self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
     
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        self.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismissAction?()
    }
    
    
    func addAllSubView() {
        
        self.insideView.addSubview(self.titleLabel)
        self.insideView.addSubview(self.stackView)
        self.insideView.addSubview(self.button)
        
        self.view.addSubview(self.insideView)
        
        NSLayoutConstraint.activate([
            
            self.insideView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.insideView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.insideView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.insideView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.insideView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.insideView.topAnchor, constant: 15),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.insideView.leadingAnchor, constant: 15),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.insideView.trailingAnchor, constant: -15),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            self.stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.stackView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80),
            
            
            self.button.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            self.button.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.insideView.bottomAnchor, constant: -10),
            self.button.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
        
    }
    
    func createInsideView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        
        
        return view
    }
    
    func createStackView(imageName: String, content: String) -> UIStackView {
        let imageView: UIImageView = .init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)?.resizeImage(targetSize: .init(width: 70, height: 70))
        imageView.contentMode = .scaleAspectFit

        
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = content
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        
        let stack: UIStackView = .init()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        return stack
        
    }
    
    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }
    
    
    func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(hex: "3472D9")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        
        
//        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        button.layer.shadowOpacity = 1.0
//        button.layer.shadowRadius = 5.0
        return button
    }
    
    @objc func buttonAction() {
        self.dismiss(animated: true)
    }
    
    
}
