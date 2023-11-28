
import Foundation

typealias HTTPHeaderField = [String: String]

typealias parameter = [String: Any]

typealias CompleteAction<T: JsonModel> = ((_ jsonModel: T?,_ error: Error?)->())

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HeaderField {
    
    case json
    
    case form
    
    var field: HTTPHeaderField {
        switch self {
        case .json:
            return [
                "Content-Type" : "application/json"
            ]
            
        case .form:
            return [
               "Content-Type" : "application/x-www-form-urlencoded"
            ]
        }
    }
}


class APIService: NSObject {
    
    static let shared = APIService()
    
    private let apiQueue = DispatchQueue(label: "api_queue", qos: .utility)

    enum URLText: String {
        case login = "http://54.199.33.241/ios_test_2/login.php?"
        case regis = "http://54.199.33.241/ios_test_2/regis.php?"
        case info = "http://54.199.33.241/ios_test_2/info.php?"
        case updateInfo = "http://54.199.33.241/ios_test_2/updateInfo.php?"
        case country1 = "http://54.199.33.241/ios_test_2/country.php"
        case citys = "http://54.199.33.241/ios_test_2/city.php"
        case sendMail = "http://54.199.33.241/ios_test_2/sendPasswordMail.php?"
        case unOrderList = "http://54.199.33.241/ios_test_2/Worker_UnOrderList.php?"
        case orderList = "http://54.199.33.241/ios_test_2/Worker_OrderList.php?"
        case workerOrderDetail = "http://54.199.33.241/ios_test_2/Worker_OrderDetail.php?"
        case showOrderInfo = "http://54.199.33.241/ios_test_2/Show_Order_Info.php?"
        case verifyCode = "http://54.199.33.241/ios_test_2/verifyCode.php?"
        case changePassword = "http://54.199.33.241/ios_test_2/changePwd.php?"
        case showGasInfo = "http://54.199.33.241/ios_test_2/Show_Gas_Info.php?"
        case regisGas = "http://54.199.33.241/ios_test_2/registGas.php?"
        case showCompanyName = "http://54.199.33.241/ios_test_2/Show_Company_Name.php?"
        case showIOT = "http://54.199.33.241/ios_test_2/Show_IOT.php?"
        case saveRemainGas = "http://54.199.33.241/ios_test_2/Save_RemainGas.php?"
        case scanNewGas = "http://54.199.33.241/ios_test_2/scanNewGas_iot.php"
        case saveNewGas = "http://54.199.33.241/ios_test_2/Save_NewGasID.php"
        case saveOriginalWeight = "http://54.199.33.241/ios_test_2/Save_OriginalWeight.php"
        case test = "http://www.yihuang.online/yihuang.online/ehun9376/testGasSeaFood.json?"
        
    }
        
    func requestWithParam<T: JsonModel>(httpMethod: HttpMethod = .post, headerField: HeaderField? = .json, urlText: URLText, params: parameter, modelType: T.Type ,  completeAction: @escaping CompleteAction<T>) {
        
        var url = urlText.rawValue
        
        switch headerField ?? .json {
        case .json:
            var paramText: [String] = []
            for param in params {
                paramText.append("\(param.key)=\(param.value)")
            }
            let paramTextUrl = paramText.joined(separator: "&")
            url = url + paramTextUrl
            
            if let text = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url = text
            }
        case .form:
            break
        }
        
        

        
//
        
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            
            for header in headerField?.field ?? [:] {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
            
            request.httpMethod = httpMethod.rawValue
            
            switch headerField ?? .json {
            case .json:
                break
            case .form:
                var requestBodyComponents = URLComponents()
                requestBodyComponents.queryItems = params.map({.init(name: $0.key, value: "\($0.value)")})

                if let requestBodyString = requestBodyComponents.percentEncodedQuery {
                    request.httpBody = Data(requestBodyString.utf8)
                }
            }

            
            self.apiQueue.async {
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

                    if let error = error {
                        completeAction(nil, error)
                    } else if let data = data {
                        do {
                            let json = try JBJson(data: data)
                            print(json)
                            completeAction(modelType.init(json: json), error)
                        } catch {
                            print(params)
                            print(error.localizedDescription)
                            print(String(data: data, encoding: .utf8))
                            completeAction(nil, error)
                        }
                    }
                }

                task.resume()
            }
        }
    }
    
}


