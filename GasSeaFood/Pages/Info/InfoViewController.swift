
import Foundation

class InfoViewController: BaseTableViewController {
    
    var viewModel: InfoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "編輯個人檔案"
        navigationItem.backBarButtonItem = .init()

        regisCellID(cellIDs: [
            "TitleTextFieldCell",
            "ButtonCell"
        ])
        self.viewModel = .init(delegate: self, adapter: .init(self.defaultTableView))
        self.viewModel?.setupRow()
    }
    
}

extension InfoViewController: InfoMethod {
    func save(success: Bool) {
        if success {
            self.showToast(message: "已更新成功", complete: {
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            self.showToast(message: "更新失敗")
        }

    }
}
