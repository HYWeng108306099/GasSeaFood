
import Foundation

protocol ForgetPasswordMethod {
    func resetButtonAction(success: Bool, message: String)
    func verifyButtonAction(success: Bool, message: String)
    func changePasswordCompletion(success: Bool, message: String)
}

class ForgerPasswordViewModel: NSObject {
    
    enum Status {
        ///輸入手機跟信箱
        case getCode
        
        ///輸入驗證碼
        case enterCode
        
        ///輸入新密碼
        case editPassword
    }
    
    var delegate: ForgetPasswordMethod?
    
    var adapter: TableViewAdapter?
    
    var number: String = ""
    
    var email: String = ""
    
    var code: String = ""
    
    var newPassword: String = ""
    
    var status: Status = .getCode
    
    init(delegate: ForgetPasswordMethod? = nil, adapter: TableViewAdapter? = nil) {
        self.delegate = delegate
        self.adapter = adapter
    }
    
    func setupRowModel() {
        
        var rowModels: [CellRowModel] = []
        
        let imageRow = TitleImageRowModel(title: "忘記密碼", imageName: "lock")
        
        let emptyRowModel = EmptyHeightRowModel(cellHeight: 87.0, color: .white)
        
        
        switch status {
            
        case .getCode:
            
            rowModels.append(imageRow)
            
            let phoneRowModel = TitleTextFieldRowModel(title: "手機號碼",
                                                       text: self.number,
                                                       placeHolder: "請輸入您的手機號碼",
                                                       textDidChange: { [weak self] text in
                self?.number = text
            })
            
            rowModels.append(phoneRowModel)
            
            let passwordRow = TitleTextFieldRowModel(title: "Email",
                                                     text: self.email,
                                                     placeHolder: "請輸入您的Email",
                                                     textDidChange: { text in
                self.email = text
            })
            
            rowModels.append(passwordRow)
            
            
            rowModels.append(emptyRowModel)
            
            let loginRowModel = ButtonCellRowModel(buttonTitle: "重新設定密碼", buttonAction: { [weak self] in
                self?.sendPasswordMail()
            })
            
            rowModels.append(loginRowModel)
            
        case .enterCode:
            
            rowModels.append(imageRow)
            
            let codeRowModel = TitleTextFieldRowModel(title: "驗證碼",
                                                      text: self.code,
                                                      placeHolder: "請輸入收到的驗證碼",
                                                      textDidChange: { [weak self] text in
                self?.code = text
            })
            
            rowModels.append(codeRowModel)
            
            
            rowModels.append(emptyRowModel)
            
            let loginRowModel = ButtonCellRowModel(buttonTitle: "重新設定密碼", buttonAction: { [weak self] in
                self?.verifyCode(Int(self?.code ?? "0") ?? 0)
            })
            
            rowModels.append(loginRowModel)
            
        case .editPassword:
            
            rowModels.append(imageRow)
            
            let newPasswordRowModel = TitleTextFieldRowModel(title: "新密碼",
                                                             text: self.newPassword,
                                                             placeHolder: "請輸入您的新密碼",
                                                             textDidChange: { [weak self] text in
                self?.newPassword = text
            })
            
            rowModels.append(newPasswordRowModel)
            
            rowModels.append(emptyRowModel)
            
            
            let loginRowModel = ButtonCellRowModel(buttonTitle: "重新設定密碼", buttonAction: { [weak self] in
                self?.changePassword(self?.newPassword ?? "")
            })
            
            rowModels.append(loginRowModel)
            
        }
        
        
        
        
        
        
        self.adapter?.updateTableViewData(rowModels: rowModels)
        
    }
    
    func sendPasswordMail() {
        
        let param: parameter = [
            "WORKER_PhoneNum": self.number,
            "WORKER_Email": self.email,
            "test": "\(Int.random(in: 0...9999))"
        ]
        
        APIService.shared.requestWithParam(httpMethod: .post, urlText: .sendMail, params: param, modelType: DefaultSuccessModel.self) { [weak self] jsonModel, error in
            self?.delegate?.resetButtonAction(success: jsonModel?.status ?? false, message: jsonModel?.message ?? "未知錯誤，請再試一次")
        }
        
    }
    
    func verifyCode(_ code: Int) {
        let param: parameter = [
            "WORKER_Verifycode": code,
            "WORKER_Email": self.email
        ]
        
        APIService.shared.requestWithParam(httpMethod: .post, urlText: .verifyCode, params: param, modelType: DefaultSuccessModel.self) { [weak self] jsonModel, error in
            self?.delegate?.verifyButtonAction(success: jsonModel?.status ?? false, message: jsonModel?.message ?? "未知錯誤，請再試一次")
        }
    }
    
    func changePassword(_ pwd: String) {
        let param: parameter = [
            "WORKER_Password": pwd,
            "WORKER_Email": self.email
        ]
        
        APIService.shared.requestWithParam(httpMethod: .post, urlText: .changePassword, params: param, modelType: DefaultSuccessModel.self) { [weak self] jsonModel, error in
            self?.delegate?.changePasswordCompletion(success: jsonModel?.status ?? false, message: jsonModel?.message ?? "未知錯誤，請再試一次")
        }
    }
}
