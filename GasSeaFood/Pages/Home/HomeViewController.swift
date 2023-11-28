
import Foundation
import UIKit

class HomeViewController: BaseTableViewController {
    
    var viewModel: HomeViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首頁"
        
        self.regisCellID(cellIDs: [
            "ButtonCell",
            "HeadInfoCell",
            "EmptyHeightCell"
        ])
        
        self.viewModel = .init(adapter: .init(self.defaultTableView), delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.setupRow()
    }
    
}

extension HomeViewController: HomeMethod {
    func logout() {
        UserInfoCenter.shared.cleanValue(.cellphoneNumber)
        self.showToast(message: "已登出") {
            let vc = LaunchViewController()
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }

    }
    
    func infoAction() {
        let vc = InfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func gotoScane() {
        let vc = QRCodeScannerViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(UINavigationController(rootViewController: vc) , animated: true)
    }
    
    func gotoList() {
        let vc = TodayListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

