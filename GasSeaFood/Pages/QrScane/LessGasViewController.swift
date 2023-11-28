

import Foundation
import UIKit

class LessGasViewController: BaseViewController {
    
    let tableView = UITableView()
    
    var adapter: TableViewAdapter?
    
    var lessGasCount: Int = 1
    
    let topView = UIView()

    var companyLabel = UILabel()
    
    var confirmButton = UIButton()
    
    var orderID: String?
    
    var companyInfoModel: CompanyInfoModel? {
        didSet {
            DispatchQueue.main.async {
                self.companyLabel.text = self.companyInfoModel?.companyName
            }
        }
    }
    
    var sensorModels: SensorDatalistModel? {
        didSet {
            self.setupRow()
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "殘氣結算"

        self.view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        tap.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(tap)

        self.setupConfirmButton()
        self.setupTopView()
        self.setupTableView()
        self.setupRow()
        
        self.getCompanyInfo()
                
    }
    
    @objc func viewAction() {
        self.view.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    func setupTopView() {
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.topView)
        
        NSLayoutConstraint.activate([
            self.topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        let lessGasTitleLabel = UILabel()
        lessGasTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        lessGasTitleLabel.text = "殘氣結算"
        lessGasTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        self.topView.addSubview(lessGasTitleLabel)
        
        NSLayoutConstraint.activate([
            lessGasTitleLabel.topAnchor.constraint(equalTo: self.topView.topAnchor,constant: 20),
            lessGasTitleLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor,constant: 20),
            lessGasTitleLabel.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor,constant: -20)
        ])
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        self.topView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: lessGasTitleLabel.bottomAnchor,constant: 10),
            stack.heightAnchor.constraint(equalToConstant: 35),
            stack.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor)
        ])
        
        let companyTitleLabel = UILabel()
        companyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        companyTitleLabel.text = "瓦斯行："
        companyTitleLabel.font = .systemFont(ofSize: 16)
        companyTitleLabel.textAlignment = .center
        
        stack.addArrangedSubview(companyTitleLabel)
        
        self.companyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.companyLabel.text = ""
        self.companyLabel.font = .systemFont(ofSize: 16)
        self.companyLabel.textAlignment = .center
        
        stack.addArrangedSubview(self.companyLabel)
        
        let inputTitleLabel = UILabel()
        inputTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        inputTitleLabel.text = "輸入殘氣結算"
        inputTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        self.topView.addSubview(inputTitleLabel)
        
        NSLayoutConstraint.activate([
            inputTitleLabel.topAnchor.constraint(equalTo: stack.bottomAnchor,constant: 50),
            inputTitleLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor,constant: 20),
            inputTitleLabel.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor,constant: -20),
            inputTitleLabel.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor,constant: -10)
        ])
    }
    
    func setupTableView() {
        
        self.adapter = .init(self.tableView)
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 10),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.confirmButton.topAnchor, constant: -10)
        ])
        
        self.tableView.register(.init(nibName: "TitleTextFieldCell", bundle: nil), forCellReuseIdentifier: "TitleTextFieldCell")
        self.tableView.register(.init(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        self.tableView.register(.init(nibName: "EmptyHeightCell", bundle: nil), forCellReuseIdentifier: "EmptyHeightCell")
        self.tableView.register(.init(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        self.tableView.register(.init(nibName: "LessGasCell", bundle: nil), forCellReuseIdentifier: "LessGasCell")
    }
    
    func setupConfirmButton() {
        
        self.confirmButton = self.createCommandButton(title: "掃瞄新瓦斯桶",
                                                      action:{
            guard self.checkSensorTime() else { return }
            self.saveRemainGas()
            
        })
        
        self.view.addSubview(self.confirmButton)
        NSLayoutConstraint.activate([
            self.confirmButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    func createCommandButton(title: String, action: (()->())?) -> UIButton {
        let button = ActionButton(action: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(hex: "3472D9")
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        
        return button
    }
    
    func gotoScanNewGas() {
        DispatchQueue.main.async {
            let vc = ScanNewGasViewController()
            vc.sensorID = self.sensorModels?.list.first?.sensorId
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func saveRemainGas() {

        let param : parameter = [
            "id": self.companyInfoModel?.customerID ?? "",
            "gas": "\(self.sensorModels?.list.first?.sensorWeight ?? 0)" ,
            "company": self.companyInfoModel?.companyID ?? ""
        ]
        
        APIService.shared.requestWithParam(headerField: .form, urlText: .saveRemainGas, params: param, modelType: DefaultResponseModel.self) { jsonModel, error in
            self.gotoScanNewGas()
        }
    }
    
    func getCompanyInfo() {
        APIService.shared.requestWithParam(headerField: .form, urlText: .showCompanyName, params: ["id": self.orderID ?? ""], modelType: CompanyInfoModel.self) { [weak self] jsonModel, error in
            if let jsonModel = jsonModel {
                
                self?.companyInfoModel = jsonModel

                APIService.shared.requestWithParam(headerField: .form, urlText: .showIOT, params: ["id": self?.companyInfoModel?.customerID ?? ""], modelType: SensorDatalistModel.self) { [weak self] jsonModel, error in
                    
                    if let jsonModel = jsonModel {
                        self?.sensorModels = jsonModel
                    } else {
                        self?.showToast(message: "取得資料失敗，請再試一次", complete: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }
                
            } else {
                self?.showToast(message: "取得資料失敗，請再試一次", complete: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func checkSensorTime() -> Bool {
        guard self.sensorModels?.list.count == 1 else {
            self.showToast(message: "僅留一個感應器, 以便做殘氣計算")
            return false
        }
        
        guard let first = self.sensorModels?.list.first else {
            self.showToast(message: "未找到感應器，請退回上一頁再試一次")
            return false
        }
        
        let dateString = first.sensorTime ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"

        if let targetDate = dateFormatter.date(from: dateString) {
            
            let timeDifference = Calendar.current.dateComponents([.minute], from:  targetDate, to: Date())
            
            if let minutes = timeDifference.minute, minutes < 30 {
                return true
            } else {
                self.showToast(message: "請先更新感應器重量")
            }
        } else {
            self.showToast(message: "日期格式錯誤")
        }
        
        return false
    }
    
    
    func setupRow() {
        var rowModels: [CellRowModel] = []
        for model in self.sensorModels?.list ?? [] {
            let rowModel = LessGasCellRowModel(sensorNumber: model.sensorId, weight: model.sensorWeight) { [weak self] id in
                guard let self = self else { return }
                let copy = self.sensorModels
                copy?.list = copy?.list.filter({$0.sensorId ?? "" != id}) ?? []
                self.sensorModels = copy
            }
            rowModels.append(rowModel)
        }
        self.adapter?.updateTableViewData(rowModels: rowModels)
        
    }
    

    
}
