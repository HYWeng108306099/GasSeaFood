
import Foundation

class GasOrderListModel: JsonModel {
    var list: [GasOrderModel] = []
    required init(json: JBJson) {
        self.list = json.arrayValue.map({GasOrderModel(json: $0)})
    }
}

class GasOrderModel: JsonModel {

    var orderID: String?
    
    var customID: String?
    
    var companyID: String?
    
    var deliveryTime: String?
    
    var deliveryCondition: String?
    
    var exchange: String?
    
    var deliveryAddress: String?
    
    var deliveryPhone: String?
    
    var gasQuantity: String?
    
    var orderTime: String?
    
    var expectTime: String?
    
    var deliveryMethod: String
    
    required init(json: JBJson) {
        self.orderID = json["ORDER_Id"].stringValue
        
        self.customID = json["CUSTOMER_Id"].stringValue
        
        self.companyID = json["COMPANY_Id"].stringValue
        
        self.deliveryTime = json["DELIVERY_Time"].stringValue
        
        self.deliveryCondition = json["DELIVERY_Condition"].stringValue
        
        self.exchange = json["Exchange"].stringValue
        
        self.deliveryAddress = json["DELIVERY_Address"].stringValue
        
        self.deliveryPhone = json["DELIVERY_Phone"].stringValue
        
        self.gasQuantity = json["Gas_Quantity"].stringValue
        
        self.orderTime = json["Order_Time"].stringValue
        
        self.expectTime = json["Expect_time"].stringValue
        
        self.deliveryMethod = json["Delivery_Method"].stringValue
    }

}
