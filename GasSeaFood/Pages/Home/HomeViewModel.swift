
import Foundation

protocol HomeMethod {
    func logout()
    func infoAction()
    func gotoScane()
    func gotoList()
}

class HomeViewModel: NSObject {
    
    var adapter: TableViewAdapter?
    
    var delegate: HomeMethod?
    
    var regisModel: RegisModel?
    
    init(adapter: TableViewAdapter? = nil, delegate: HomeMethod? = nil) {
        self.adapter = adapter
        self.delegate = delegate
    }
    
    func setupRow() {
        
        let cellPhoneNumber = UserInfoCenter.shared.loadValue(.cellphoneNumber) as? String ?? ""

        InfoHelper.shared.getRegisModel(cellPhoneNumber: cellPhoneNumber) { [weak self] model in
            guard let self = self else { return }
            self.regisModel = model
            
            var rowModels: [CellRowModel] = []

            let empty = EmptyHeightRowModel(cellHeight: 100, color: .white)

            rowModels.append(empty)

            let nameRow = HeadInfoRowModel(name: self.regisModel?.name ?? "",
                                           infoAction: {
                self.delegate?.infoAction()
            },
                                           logoutAcction: {
                self.delegate?.logout()
            })

            rowModels.append(nameRow)
            

            let todayListRow = ButtonCellRowModel(buttonTitle: "今日訂單", buttonHeight: 150, buttonAction: {
                self.delegate?.gotoList()
            })

            rowModels.append(todayListRow)

//            let scanRow = ButtonCellRowModel(buttonTitle: "前往掃描頁面", buttonHeight: 150, buttonAction: {
//                self.delegate?.gotoScane()
//            })
//
//            rowModels.append(scanRow)

            self.adapter?.updateTableViewData(rowModels: rowModels)
        }

    }
    
}
