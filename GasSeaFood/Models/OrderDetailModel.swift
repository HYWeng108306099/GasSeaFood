
import Foundation

class OrderDetailListModel: JsonModel {
    var list: [OrderDetailModel] = []
    
    required init(json: JBJson) {
        if let jsonArray = json.array {
            self.list = jsonArray.map { OrderDetailModel(json: $0) }
        }
    }
}

class OrderDetailModel: JsonModel {
    
    var exchange: String?
    
    var orderID: String?
    
    var orderQuantity: String?
    
    var gasDetailId: String?
    
    var orderType: String?
    
    var orderWeight: String?
    
    required init(json: JBJson) {
        self.exchange = json["exchange"].stringValue
        self.orderID = json["Order_ID"].stringValue
        self.orderQuantity = json["Order_Quantity"].stringValue
        self.gasDetailId = json["Gas_Detail_Id"].stringValue
        self.orderType = json["Order_type"].stringValue
        self.orderWeight = json["Order_weight"].stringValue
    }
}
