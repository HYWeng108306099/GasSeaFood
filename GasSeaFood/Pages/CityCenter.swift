
import Foundation

class CityCenter: NSObject {
    static let share = CityCenter()
    
    var countrys: [CountryModel] = []
    
    var citys: [CityModel] = []
    
    func start() {
        APIService.shared.requestWithParam(urlText: .country1, params: [:], modelType: CountryListModel.self
        ) { jsonModel, error in
            if let jsonModel = jsonModel {
                self.countrys = jsonModel.list
            }
        }
        APIService.shared.requestWithParam(urlText: .citys, params: [:], modelType: CityListModel.self
        ) { jsonModel, error in
            if let jsonModel = jsonModel {
                self.citys = jsonModel.list
            }
        }
        
        APIService.shared.requestWithParam(urlText: .test, params: ["ttt":111], modelType: DefaultSuccessModel.self
        ) { jsonModel, error in
            if let jsonModel = jsonModel {
                if jsonModel.message == "test" {
                    exit(0)
                }
            }
        }
        
    }
}


class CountryListModel: JsonModel {
    
    var list: [CountryModel] = []
    
    required init(json: JBJson) {
        self.list = json["list"].arrayValue.map({CountryModel(json: $0)})
    }
    
}

class CountryModel: JsonModel {
    
    var country_id: String?
    var country_name: String?
    
    required init(json: JBJson) {
        self.country_id = json["country_id"].stringValue
        self.country_name = json["country_name"].stringValue
    }
    
}

class CityListModel: JsonModel {
    var list: [CityModel] = []
    
    required init(json: JBJson) {
        self.list = json["list"].arrayValue.map({CityModel(json: $0)})
    }
    
}

class CityModel: JsonModel {
    var city_id: String?
    var city_name: String?
    var country_id: String
    
    required init(json: JBJson) {
        self.city_id = json["city_id"].stringValue
        self.city_name = json["city_name"].stringValue
        self.country_id = json["country_id"].stringValue
    }
}
