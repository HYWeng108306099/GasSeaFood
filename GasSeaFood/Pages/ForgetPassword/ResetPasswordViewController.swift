
import Foundation
import UIKit

class ResetPasswordViewController: BaseTableViewController {
    
    var viewModel: ResetPasswordViewModel?
    
    convenience init(
        model: RegisModel
    ){
        self.init()
        self.viewModel = .init(delegate: self, adapter: .init(self.defaultTableView), regisModel: model)
    }
    
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
        self.viewModel?.setupRowModel()
    }
    
    
}

extension ResetPasswordViewController: ResetPasswordViewMethod {
    
    func saveAndReturnAction(success: Bool) {
        self.showToast(message: success ? "已重設密碼" : "發生錯誤，請再試一次",complete: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
}
