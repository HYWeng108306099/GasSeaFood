
import Foundation
import AVFoundation
import UIKit

class ScanNewGasViewController: BaseViewController {

    var captureSession: AVCaptureSession!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let alertLabel: UILabel = .init()

    let preview: UIView = .init()
    
    let tableView = UITableView()
    
    var adapter: TableViewAdapter?
    
    var titleRow:EmptyHeightRowModel?
    
    var orderID: String?
    
    var sensorID: String?
    
    var code: String = "" {
        didSet {
            self.titleRow?.attr = self.createAttr(id: code)
            self.titleRow?.updateCellView()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        tap.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(tap)
        
        self.setupAVSession()
        
        self.setupPreview()
        
        self.setupTableView()
        
        self.setupRow()
                
    }
    
    @objc func viewAction() {
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(!hasOld, animated: false)

        if (captureSession?.isRunning == false) {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)

        if (captureSession?.isRunning == true) {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func setupTableView() {
        
        self.adapter = .init(self.tableView)
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.preview.bottomAnchor, constant: 10),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
        
        self.tableView.register(.init(nibName: "TitleTextFieldCell", bundle: nil), forCellReuseIdentifier: "TitleTextFieldCell")
        self.tableView.register(.init(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        self.tableView.register(.init(nibName: "EmptyHeightCell", bundle: nil), forCellReuseIdentifier: "EmptyHeightCell")
        self.tableView.register(.init(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    }
    
    func createAttr(id: String) -> NSMutableAttributedString {
        let firstAttr = NSMutableAttributedString(string: "原瓦斯桶ID: \(id)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ])
        return firstAttr
    }
    
    
    func setupRow(code: String? = nil) {
        
        var rowModels: [CellRowModel] = []
        
        let numberRow = TitleTextFieldRowModel(title: "輸入瓦斯桶編號", placeHolder: "請輸入您的瓦斯桶編號") { [weak self] text in
            self?.code = text
        }
        
        rowModels.append(numberRow)
        
        self.titleRow = EmptyHeightRowModel(cellHeight: 200, color: .white, attr: createAttr(id: code ?? ""), textAligment: .center)

        if let titleRow = titleRow {
            rowModels.append(titleRow)
        }
        
        let buttonRow = ButtonCellRowModel(buttonTitle: "確認完成", buttonAction: { [weak self] in
            guard self?.code ?? "" != "" else {
                self?.showSingleAlert(message: "請先輸入或掃描取得瓦斯桶編號")
                return
            }
            self?.checkGasID(gasID: self?.code ?? "",
                             complete: { isResponseSuccess, gasModel in
                
                if isResponseSuccess,
                    let gasModel = gasModel {
                    self?.scanNewGas(model: gasModel)
                } else {
                    self?.showToast(message: "此瓦斯桶尚未註冊",
                                    complete: {
                        self?.gotoRegisGasVC()
                    })
                }
                
            })
        })
        
        rowModels.append(buttonRow)
        
        self.adapter?.updateTableViewData(rowModels: rowModels)
        
    }
    
    func scanNewGas(model: GasDetailModel) {
        
        let param: parameter = [
            "gasId": model.gasID ?? "",//TODO: - GasID
            "gasWeightEmpty":"",//TODO: - GasID
            "sensorId": self.sensorID ?? ""
        ]
        
        APIService.shared.requestWithParam(headerField: .form,
                                           urlText: .scanNewGas,
                                           params: param,
                                           modelType: DefaultResponseModel.self) { jsonModel, error in
            if let jsonModel = jsonModel,jsonModel.isResponseSuccess() {
                self.showToast(message: "換桶成功") {
                    self.backToOrderDetailVC()
                }
                
            } else {
                
                self.showToast(message: "換桶失敗，請再試一次") {
                    self.backToOrderDetailVC()
                }
            }
        }
    }
        
    func backToOrderDetailVC() {
        DispatchQueue.main.async {
            if let detailVC = self.navigationController?.viewControllers.first(where: {$0 is OrderDetailViewController}) as? OrderDetailViewController {
                detailVC.successSensorID = self.sensorID
                self.navigationController?.popToViewController(detailVC, animated: true)
            }
        }
    }
    
    func setupImageView() {
        
        let imageView: UIImageView = .init()
        
        imageView.image = .init(named: "focus")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.preview.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.preview.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: self.preview.bottomAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: self.preview.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: self.preview.trailingAnchor, constant: -20),
        ])
    }
    
    func setupAlertLabel(hasOld: Bool) {
        
        for view in self.preview.subviews {
            if let view = view as? UILabel {
                view.removeFromSuperview()
            }
        }
        
        self.alertLabel.translatesAutoresizingMaskIntoConstraints = false
        self.alertLabel.textAlignment = .center
        self.alertLabel.font = .systemFont(ofSize: 24, weight: .bold)
        self.alertLabel.textColor = .lightGray
        
        self.preview.addSubview(self.alertLabel)
        
        NSLayoutConstraint.activate([
            self.alertLabel.topAnchor.constraint(equalTo: self.preview.topAnchor),
            self.alertLabel.leadingAnchor.constraint(equalTo: self.preview.leadingAnchor),
            self.alertLabel.trailingAnchor.constraint(equalTo: self.preview.trailingAnchor),
            self.alertLabel.bottomAnchor.constraint(equalTo: self.preview.bottomAnchor)
        ])
        
    }
    
    func setupPreview() {
        self.preview.layer.addSublayer(previewLayer)
        self.previewLayer.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 60)
        
        self.preview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(preview)
        
        NSLayoutConstraint.activate([
            self.preview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.preview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.preview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.preview.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60),
        ])
        
        self.setupImageView()
        self.setupAlertLabel(hasOld: false)
    }
    
    func showAlert(success: Bool, complete: (()->())? = nil) {
        
        let alert = CustomAlertController(title: success ? "瓦斯桶配對成功" : "換桶失敗",
                                          content: success ? "已通知換桶成功" : "請重新掃描",
                                          imageName: success ? "success" : "faild",
                                          buttonTitle: "確定",
                                          dismissAction: {
            complete?()
        })
        self.present(alert, animated: true)
    }
    
    func checkGasID(gasID: String, complete: ((Bool, GasDetailModel?)->())? ) {
        
        APIService.shared.requestWithParam(headerField: .form,
                                           urlText: .showGasInfo,
                                           params: ["id": gasID],
                                           modelType: GasDetailModel.self) { [weak self] jsonModel, error in
            if let jsonModel = jsonModel {
                complete?(jsonModel.isResponseSuccess(), jsonModel)
            } else {
                self?.showSingleAlert(message: "檢查失敗，請再試一次")
            }
        }
    }
    
    func gotoLessGasVC() {
        DispatchQueue.main.async {
            let lessGasVC = LessGasViewController()
            lessGasVC.orderID = self.orderID
            self.navigationController?.pushViewController(lessGasVC, animated: true)
        }

    }
    
    func gotoRegisGasVC() {
        DispatchQueue.main.async {
            let vc = RegisGasViewController()
            vc.orderID = self.orderID
            vc.isNew = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    func found(code: String) {
        
        self.code = code
 
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScanNewGasViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                
                self.showAlert(success: false, complete: { [weak self] in
                    DispatchQueue.global().async {
                        self?.captureSession.startRunning()
                    }
                })
                return
            }
            self.found(code: stringValue)
        }

        
    }
    
    func setupAVSession() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill

        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}
