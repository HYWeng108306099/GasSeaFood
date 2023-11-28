
import Foundation
import UIKit


class LessGasCellRowModel: CellRowModel {
    override func cellReUseID() -> String {
        return "LessGasCell"
    }
    init(sensorNumber: String? = nil, weight: Int? = nil, cutButtonAction: ((String) -> ())? = nil) {
        self.sensorNumber = sensorNumber
        self.weight = weight
        self.cutButtonAction = cutButtonAction
    }
    
    var sensorNumber: String?
    var weight: Int?
    var cutButtonAction: ((_ sensorNumber: String)->())?
}


class LessGasCell: UITableViewCell {
    @IBOutlet weak var cutButton: UIButton!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    var rowModel: LessGasCellRowModel?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        
        self.cutButton.setTitle("—", for: .normal)
        self.cutButton.setTitleColor(.white, for: .normal)
        self.cutButton.backgroundColor = .gray
        self.cutButton.layer.cornerRadius = 5
        self.cutButton.clipsToBounds = true
        self.cutButton.addTarget(self, action: #selector(cutButtonAction), for: .touchUpInside)
        
        self.idLabel.font = .systemFont(ofSize: 16)
        self.idLabel.adjustsFontSizeToFitWidth = true
        
        self.weightLabel.font = .systemFont(ofSize: 16)
        self.weightLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    @objc func cutButtonAction() {
        self.rowModel?.cutButtonAction?(self.rowModel?.sensorNumber ?? "")
    }
    
}



extension LessGasCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? LessGasCellRowModel else { return }
        self.rowModel = rowModel
        self.weightLabel.text = "\(rowModel.weight ?? 0)  公斤"
        self.idLabel.text = "感應器 \(rowModel.sensorNumber ?? "")"
        
    }
}
