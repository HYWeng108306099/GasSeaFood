
import Foundation
import UIKit

class TodayListController: BaseTableViewController {
    
    var viewModel: TodayListViewModel?
    
    let segmentControl: UISegmentedControl = .init(items: ["未完成","已完成"])
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "今日訂單"
        self.regisCellID(cellIDs: [
            "TodayListCell",
            "EmptyHeightCell"
        ])
        self.setSegmentControl()
        self.resetTableView()
        self.viewModel = .init(delegate: self, adapter: .init(self.defaultTableView))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.getGasOrderAPI(index: self.index)
    }
    
    
    
    func setSegmentControl() {
        self.segmentControl.selectedSegmentIndex = self.index
        self.segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.segmentControl.addTarget(self, action: #selector(changePage(_:)), for: .valueChanged)
        
        self.view.addSubview(self.segmentControl)
        
        NSLayoutConstraint.activate([
            self.segmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.segmentControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.segmentControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.segmentControl.heightAnchor.constraint(equalToConstant: 25),
        ])
        
    }
    
    @objc func changePage(_ sender: UISegmentedControl) {
        self.index = sender.selectedSegmentIndex
        self.viewModel?.getGasOrderAPI(index: self.index)
    }
    
    
    func resetTableView() {
        self.defaultTableView.removeFromSuperview()
        
        self.view.addSubview(self.defaultTableView)
        
        NSLayoutConstraint.activate([
            self.defaultTableView.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor, constant: 15),
            self.defaultTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.defaultTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.defaultTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
        ])
        
    }
        
}
extension TodayListController: TodayListMethod {
    func cellDidSelect(model: GasOrderModel) {
        let vc = OrderDetailViewController()
        vc.naviTitle = model.orderID ?? ""
        vc.gasOrderModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

