
import Foundation
/*
{
  "Customer_Id" : "6",
  "response" : "success",
  "Company_Name" : "Company1",
  "COMPANY_Id" : "1"
}
 */

class CompanyInfoModel: JsonModel {
    var customerID: String?
    var response: String?
    var companyName: String?
    var companyID: String?
    
    required init(json: JBJson) {
        self.customerID = json["Customer_Id"].stringValue
        self.response = json["response"].stringValue
        self.companyName = json["Company_Name"].stringValue
        self.companyID = json["COMPANY_Id"].stringValue
    }
}
