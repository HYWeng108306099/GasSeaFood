
import Foundation

protocol InfoMethod {
    func save(success: Bool)
}

class InfoViewModel: NSObject {
    
    var delegate: InfoMethod?
    
    var adapter: TableViewAdapter?
    
    var defaultNumber: String = ""
    
    var regisModel: RegisModel?
    
    init(delegate: InfoMethod? = nil, adapter: TableViewAdapter? = nil) {
        self.delegate = delegate
        self.adapter = adapter
    }
    
    func setupRow() {
        let cellPhoneNumber = UserInfoCenter.shared.loadValue(.cellphoneNumber) as? String ?? ""

        InfoHelper.shared.getRegisModel(cellPhoneNumber: cellPhoneNumber) { [weak self] model in
            guard let self = self else { return }
            self.regisModel = model
            
            var rowModels: [CellRowModel] = []
            
            let nameRow = TitleTextFieldRowModel(title: "姓名", text: self.regisModel?.name ?? "", placeHolder: "請輸入姓名", required: true) { text in
                self.regisModel?.name = text
            }
            
            rowModels.append(nameRow)
            
            let cellphoneRow = TitleTextFieldRowModel(title: "手機號碼", text: self.regisModel?.cellphoneNumber ?? "", placeHolder: "請輸入姓名", required: true, canEdit: false) { text in
                self.regisModel?.cellphoneNumber = text
            }
            
            rowModels.append(cellphoneRow)
            
            let gasRow = TitleTextFieldRowModel(title: "瓦斯行", text: self.regisModel?.gas ?? "", placeHolder: "請輸入所屬瓦斯行", required: true) { text in
                self.regisModel?.gas = text
            }
            
            rowModels.append(gasRow)
            
            let emailRow = TitleTextFieldRowModel(title: "電子信箱", text: self.regisModel?.email ?? "", placeHolder: "請輸入電子郵件", required: true) { text in
                self.regisModel?.email = text
            }
            
            rowModels.append(emailRow)
            
            let saveRow = ButtonCellRowModel(buttonTitle: "儲存", buttonHeight: 50, buttonAction: {
                //http://54.199.33.241/ios_test_2/updateInfo.php?phone=yyy&store=kou&name=anna&email=anna@gmail
                
                let param: parameter = [
                    "WORKER_PhoneNum": UserInfoCenter.shared.loadValue(.cellphoneNumber) as? String ?? "",
                    "WORKER_Name": self.regisModel?.name ?? "",
                    "WORKER_Email": self.regisModel?.email ?? ""
                ]
                
                APIService.shared.requestWithParam(headerField: .form,urlText: .updateInfo, params: param, modelType: DefaultSuccessModel.self) { jsonModel, error in
                    self.delegate?.save(success: jsonModel?.status ?? false)
                }
            })
            
            rowModels.append(saveRow)
            
            self.adapter?.updateTableViewData(rowModels: rowModels)
            
        }
        
        
    }
    
}
