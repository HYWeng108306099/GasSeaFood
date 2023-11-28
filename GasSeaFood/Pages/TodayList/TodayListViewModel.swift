
import Foundation
import UIKit

protocol TodayListMethod {
    func cellDidSelect(model: GasOrderModel)
}

class TodayListViewModel: NSObject {
    
    
    var delegate: TodayListMethod?
    
    var adapter: TableViewAdapter?
    
    init(delegate: TodayListMethod? = nil, adapter: TableViewAdapter? = nil) {
        self.delegate = delegate
        self.adapter = adapter
    }
    
    var unOrderListModel: GasOrderListModel?
    
    var orderListModel: GasOrderListModel?
    
    
    func setupRow(index: Int = 0) {
                
        var rowModels: [CellRowModel] = []
        
        if index == 0 {
            for order in self.unOrderListModel?.list ?? [] {
                let row = TodayListCellRowModel(title: order.deliveryAddress,
                                                titleLabelAction: { [weak self] in
                    self?.delegate?.cellDidSelect(model: order)
                })
                rowModels.append(row)
            }
        } else {
            for order in self.orderListModel?.list ?? [] {
                let row = TodayListCellRowModel(title: order.deliveryAddress,
                                                titleLabelAction: { [weak self] in
                    self?.delegate?.cellDidSelect(model: order)
                })
                rowModels.append(row)
            }
        }
        
        if rowModels.isEmpty {
            let firstAttr = NSMutableAttributedString(string: "無訂單", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ])
            
            rowModels.append(EmptyHeightRowModel(cellHeight: 300,attr: firstAttr))
        }
        
        self.adapter?.updateTableViewData(rowModels: rowModels)
    }
    
    
    func getGasOrderAPI(index: Int) {
        var id = 0
        InfoHelper.shared.getRegisModel(cellPhoneNumber: UserInfoCenter.shared.loadValue(.cellphoneNumber) as? String ?? "") { regisModel in
            id = regisModel?.id ?? 0
            
            if index == 0 {
                APIService.shared.requestWithParam( headerField: .form, urlText: .unOrderList, params: ["id": id], modelType: GasOrderListModel.self) { jsonModel, error in
                    self.unOrderListModel = jsonModel
                    self.setupRow()
                }
            } else {
                APIService.shared.requestWithParam( headerField: .form, urlText: .orderList, params: ["id": id], modelType: GasOrderListModel.self) { jsonModel, error in
                    self.unOrderListModel = jsonModel
                    self.setupRow()
                }
            }

        }

    }
    
}
