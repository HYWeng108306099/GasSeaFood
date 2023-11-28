
import Foundation
import UIKit

class RegisModel: JsonModel {

    
    var id: Int?
    
    var name: String?

    var sex: String?
    
    var address: String?
    
    var cellphoneNumber: String?
    
    var phoneNumber: String?
    
    var email: String?
    
    var password: String?
    
    var confirmPassword: String?
    
    var inviewCode: String?
    
    var gas: String?
    
    var rule: Bool = false
    
    required init(json: JBJson) {
        
        self.id = json["WORKER_Id"].intValue
        self.name = json["WORKER_Name"].stringValue
        self.sex = json["WORKER_Sex"].stringValue
        self.cellphoneNumber = json["WORKER_PhoneNum"].stringValue
        
        self.gas = json["store"].stringValue
        self.address = json["WORKER_Address"].stringValue
        self.email = json["WORKER_Email"].stringValue
    }
    
    init() {
        
    }
    
}

protocol RegisMethod {
    func regisComplete(success: Bool, message: String)
}

class RegisViewModel: NSObject {
    
    var delegate: RegisMethod?
    
    var adapter: TableViewAdapter?
    
    var regisModel = RegisModel()
    
    init(delegate: RegisMethod? = nil, adapter: TableViewAdapter? = nil) {
        self.delegate = delegate
        self.adapter = adapter
    }
    
    func setupRow() {
        
        var rowModels: [CellRowModel] = []
        
        
        let nameRow = TitleTextFieldRowModel(title: "名字",
                                             text: self.regisModel.name,
                                                textDidChange: { [weak self] text in
            self?.regisModel.name = text
        })
        
        rowModels.append(nameRow)
        
        let sexRow = GenderTwoButtonRowModel(buttonAction: { [weak self] text in
            self?.regisModel.sex = text
        })
        
        rowModels.append(sexRow)
        
        let addressRow = TitleTwoButtonsTextfieldRowModel(title: "居住地址",
                                                          country: "縣/市",
                                                          area: "地區",
                                                          textDidChange: {[weak self] text in
            self?.regisModel.address = text
        })
        
        rowModels.append(addressRow)
        
//        let addressRow = TitleTextFieldRowModel(title: "居住地址",
//                                                 textDidChange: { [weak self] text in
//
//        })
//
//        rowModels.append(addressRow)
        
        let cellphoneRow = TitleTextFieldRowModel(title: "手機號碼",
                                                  text: self.regisModel.cellphoneNumber,
                                                 textDidChange: { [weak self] text in
            self?.regisModel.cellphoneNumber = text
        })
        
        rowModels.append(cellphoneRow)
        
        let phoneRow = TitleTextFieldRowModel(title: "市內電話號碼",
                                              text: self.regisModel.phoneNumber,
                                                 textDidChange: { [weak self] text in
            self?.regisModel.phoneNumber = text
        })
        
        rowModels.append(phoneRow)
        
        let emailRow = TitleTextFieldRowModel(title: "電子信箱",
                                              text: self.regisModel.email,
                                                 textDidChange: { [weak self] text in
            self?.regisModel.email = text
        })
        
        rowModels.append(emailRow)
        
        let passwordRow = TitleTextFieldRowModel(title: "密碼",
                                                 text: self.regisModel.password,
                                                 textDidChange: { [weak self] text in
            self?.regisModel.password = text
        })
        
        rowModels.append(passwordRow)
        
        let confirmPasswordRow = TitleTextFieldRowModel(title: "確認密碼",
                                                        text: self.regisModel.confirmPassword,
                                                 textDidChange: { [weak self] text in
            self?.regisModel.confirmPassword = text
        })
        
        rowModels.append(confirmPasswordRow)
        
        let inviteCodeRow = TitleTextFieldRowModel(title: "家人邀請碼",
                                                   text: self.regisModel.inviewCode,
                                                   required: false,
                                                   textDidChange: { [weak self] text in
            self?.regisModel.inviewCode = text
        })
        
        rowModels.append(inviteCodeRow)
        
        let ruleRow = LabelCellRowModel(titleAttr: .init(string: "服務條款",
                                                         attributes: [
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]),
                                        needImage: true,
                                        labelTapAction: {
            self.regisModel.rule.toggle()
        })
        
        rowModels.append(ruleRow)
        
        let regisRowModel = ButtonCellRowModel(buttonTitle: "完成註冊", buttonAction: { [weak self] in
            
            
//        http://54.199.33.241/ios_test_2/regis.php?WORKER_Name=anna&WORKER_Sex=M&WORKER_PhoneNum=0987721&WORKER_HouseTelpNo=2603&WORKER_Password=1234&WORKER_Email=ehun@gmail&WORKER_Address=tai&WORKER_Company_Id=16776387
            
            let param: parameter = [
                "WORKER_Name" : self?.regisModel.name ?? "default",
                "WORKER_Sex" : self?.regisModel.sex ?? "default",
                "WORKER_PhoneNum" : self?.regisModel.cellphoneNumber ?? "default",
                "WORKER_HouseTelpNo" : self?.regisModel.phoneNumber ?? "default",
                "WORKER_Password" : self?.regisModel.password ?? "default",
                "WORKER_Email" : self?.regisModel.email ?? "default",
                "WORKER_Address" : self?.regisModel.address ?? "default",
                "WORKER_Company_Id" : 16776387
            ]
            
            APIService.shared.requestWithParam(urlText: .regis, params: param, modelType: DefaultSuccessModel.self) { jsonModel, error in
                self?.delegate?.regisComplete(success: jsonModel?.status ?? true, message: jsonModel?.message ?? "")
            }
            
            
        })
        
        rowModels.append(regisRowModel)
        
        
        
        
        self.adapter?.updateTableViewData(rowModels: rowModels)
    }
    
}
