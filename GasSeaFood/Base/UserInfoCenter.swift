

import Foundation
import UIKit



class UserInfoCenter: NSObject {
    
    static let shared = UserInfoCenter()
    
    enum UserInfoDataType: String {
       case cellphoneNumber
    }
    
    func storeValue(_ type: UserInfoDataType, data: Any?) {
        UserDefaults.standard.set(data, forKey: type.rawValue)
    }
    
    func loadValue(_ type: UserInfoDataType) -> Any? {
        if let something = UserDefaults.standard.object(forKey: type.rawValue) {
            return something
        } else {
            return nil
        }
    }
    
    func cleanValue(_ type: UserInfoDataType) {
        UserDefaults.standard.removeObject(forKey: type.rawValue)
    }
    
    func storeData<T: Codable>(model: T, _ type: UserInfoDataType) {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: type.rawValue)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func loadData<T: Codable>(modelType: T.Type, _ type: UserInfoDataType) -> T? {
        let decoder = JSONDecoder()
        
        do {
            if let data = UserInfoCenter.shared.loadValue(type) as? Data {
                let model = try decoder.decode(modelType, from: data)
                return model
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
    
 
    
}
