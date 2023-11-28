

import Foundation

class DefaultSuccessModel: JsonModel {
    
    var status: Bool = true
    
    var message: String = ""
    
    required init(json: JBJson) {
        self.status = json["status"].booleanValue
        self.message = json["message"].stringValue
    }
    
}

class DefaultResponseModel: JsonModel {
    
    var response: String?
    
    required init(json: JBJson) {
        self.response = json["response"].stringValue
    }
    
    func isResponseSuccess() -> Bool {
        return self.response == "success"
    }
    
    func isResponseDuplicate() -> Bool {
        return self.response == "Duplicate"
    }
    
    func isResponseSmaller() -> Bool {
        return self.response == "smaller"
    }
    
    
    
}
