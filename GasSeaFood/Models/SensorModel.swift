

import Foundation

/*
 [
   {
     "SENSOR_Id" : "1",
     "SENSOR_Weight" : 12,
     "SENSOR_Battery" : "正常",
     "SENSOR_Time" : "2023-09-07 15:30:04.910000",
     "response" : "success"
   }
 ]
 */
class SensorDatalistModel: JsonModel {
    var list: [SensorDataModel] = []
    required init(json: JBJson) {
        self.list = json.arrayValue.map({SensorDataModel(json: $0)})
    }
}

class SensorDataModel: JsonModel {
    var sensorId: String?
    var sensorWeight: Int?
    var sensorBattery: String?
    var sensorTime: String?
    var response: String?
    
    required init(json: JBJson) {
        self.sensorId = json["SENSOR_Id"].stringValue
        self.sensorWeight = json["SENSOR_Weight"].intValue
        self.sensorBattery = json["SENSOR_Battery"].stringValue
        self.sensorTime = json["SENSOR_Time"].stringValue
        self.response = json["response"].stringValue
    }
}


