
import Foundation
import UIKit

class ForgetPasswordViewController: BaseTableViewController {
    
    var viewModel: ForgerPasswordViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultTableView.separatorStyle = .none
        self.regisCellID(cellIDs: [
            "TitleImageCell",
            "TitleTextFieldCell",
            "LabelCell",
            "ButtonCell",
            "EmptyHeightCell"
        ])
        self.viewModel = .init(delegate: self, adapter: .init(self.defaultTableView))
        self.viewModel?.setupRowModel()
    }
    
    
}

extension ForgetPasswordViewController: ForgetPasswordMethod {
    
    func resetButtonAction(success: Bool, message: String) {
        DispatchQueue.main.async {
            self.showSingleAlert(title: "提示", message: message, confirmTitle: "OK", confirmAction: { [weak self] in
                if success {
                    self?.viewModel?.status = .enterCode
                    self?.viewModel?.setupRowModel()
                }
            })
        }

    }
    
    func verifyButtonAction(success: Bool, message: String) {
        DispatchQueue.main.async {
            self.showSingleAlert(title: "提示", message: message, confirmTitle: "OK", confirmAction: { [weak self] in
                if success {
                    self?.viewModel?.status = .editPassword
                    self?.viewModel?.setupRowModel()
                }
            })
        }
        

    }
    
    func changePasswordCompletion(success: Bool, message: String) {
        DispatchQueue.main.async {
            self.showSingleAlert(title: message, confirmTitle: "OK") { [weak self] in
                if success {
                    self?.dismiss(animated: true)
                }
            }
        }
    }

}
