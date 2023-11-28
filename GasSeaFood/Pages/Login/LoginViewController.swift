
import Foundation
import UIKit

class LoginViewController: BaseTableViewController {
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        self.regisCellID(cellIDs: [
            "TitleImageCell",
            "TitleTextFieldCell",
            "LabelCell",
            "ButtonCell",
            "EmptyHeightCell"
        ])

        self.viewModel = .init(adapter: .init(self.defaultTableView), delegate: self)
        self.viewModel?.setupRow()
        
    }

}

extension LoginViewController: LoginMethod {

    func loginComplete(success: Bool) {
        
        if success {
            
                self.showToast(message: "登入成功", complete: {
                    let vc = UINavigationController(rootViewController: HomeViewController())
                    UIApplication.shared.windows.first?.rootViewController = vc
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                })
            

        } else {
            self.showToast(message: "帳號密碼錯誤")
        }

    }
    
    
    func forgetPasswordAction() {
        let vc = ForgetPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
