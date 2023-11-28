
import Foundation


protocol ResetPasswordViewMethod {
    func saveAndReturnAction(success: Bool)
}

class ResetPasswordViewModel: NSObject {
    
    var delegate: ResetPasswordViewMethod?
    
    var adapter: TableViewAdapter?
    
    var regisModel: RegisModel?
    
    var password: String = ""
    
    init(delegate: ResetPasswordViewMethod? = nil, adapter: TableViewAdapter? = nil, regisModel: RegisModel?) {
        self.delegate = delegate
        self.adapter = adapter
        self.regisModel = regisModel
    }
    
    
    func setupRowModel() {
        
        var rowModels: [CellRowModel] = []
        
        let imageRow = TitleImageRowModel(title: "忘記密碼", imageName: "lock")
        
        rowModels.append(imageRow)
        
        let phoneRowModel = TitleTextFieldRowModel(title: "設定新密碼",
                                                placeHolder: "請輸入您的新密碼",
                                                textDidChange: { [weak self] text in
            self?.password = text
        })
        
        rowModels.append(phoneRowModel)
        
        let passwordRow = TitleTextFieldRowModel(title: "再次輸入新密碼",
                                                 placeHolder: "請再次輸入新密碼",
                                                 textDidChange: { text in
            
        })
        
        rowModels.append(passwordRow)
        
        let emptyRowModel = EmptyHeightRowModel(cellHeight: 87.0, color: .white)
        
        rowModels.append(emptyRowModel)
        
        let loginRowModel = ButtonCellRowModel(buttonTitle: "返回登入畫面", buttonAction: { [weak self] in
            
//            if var array = UserInfoCenter.shared.loadData(modelType: [RegisModel].self, .regisModelList) {
//                array = array.filter({$0.cellphoneNumber != self?.regisModel?.phoneNumber ?? ""})
//                self?.regisModel?.password = self?.password ?? ""
//                if let model = self?.regisModel {
//                    array.append(model)
//                    UserInfoCenter.shared.storeData(model: array, .regisModelList)
//                    self?.delegate?.saveAndReturnAction(success: true)
//                    return
//                }
//            }
            self?.delegate?.saveAndReturnAction(success: false)
            
        })
        
        rowModels.append(loginRowModel)
        
        self.adapter?.updateTableViewData(rowModels: rowModels)
        
    }
}

