
import Foundation
//{"CUSTOMER_Id":"1","CUSTOMER_Name":"\u6e2c\u8a66\u7528\u5e33\u865f","CUSTOMER_Sex":"1","CUSTOMER_PhoneNo":"0987162501","CUSTOMER_City":"\u53f0\u5317\u5e02","CUSTOMER_District":"\u4e2d\u5c71\u5340","CUSTOMER_Address":"\u53f0\u5317\u5e02\u4e2d\u5c71\u5340\u53f0\u5317\u8eca\u7ad9","CUSTOMER_HouseTelpNo":"0287871111","CUSTOMER_Password":"1234","CUSTOMER_Email":"joh1234567892001@gmail.com","CUSTOMER_Point":"10000","CUSTOMER_FamilyMemberId":"878711111","COMPANY_Id":"16776387","COMPANY_HistoryID":"87871111"}
class CustomModel: JsonModel {
    
    var customName: String?
    
    required init(json: JBJson) {
        self.customName = json["Order_Name"].stringValue
    }
}
