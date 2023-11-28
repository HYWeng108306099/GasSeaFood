

import Foundation

//$GAS_Id = $row['GAS_Id'];
// $GAS_Volume = $row['GAS_Volume'];
// $GAS_Type = $row['GAS_Type'];
// $gas_data = array();
// $gas_data['GAS_Id'] = $GAS_Id;
// $gas_data['GAS_Volume'] = $GAS_Volume;
// $gas_data['GAS_Type'] = $GAS_Type;
// $gas_data['response'] = 'success';

class GasDetailModel: JsonModel {
    
    var response: String?
    var gasID: String?
    
    required init(json: JBJson) {
        self.response = json["response"].stringValue
        self.gasID = json["GAS_Id"].stringValue
        print(json)
    }
    
    func isResponseSuccess() -> Bool {
        return self.response == "success"
    }
    
    func isResponseDuplicate() -> Bool {
        return self.response == "Duplicate"
    }
}
