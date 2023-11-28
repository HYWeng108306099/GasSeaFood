
import Foundation
import UIKit
class TwoButtonCellRowModel: CellRowModel {
    init(leftTitle: String? = nil, righttitle: String? = nil, leftButtonAction: (() -> ())? = nil, rightButtonAction: (() -> ())? = nil) {
        self.leftTitle = leftTitle
        self.righttitle = righttitle
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
    }
    
    override func cellReUseID() -> String {
        return "TwoButtonCell"
    }
    
    var leftTitle: String?
    var righttitle: String?
    var leftButtonAction: (()->())?
    var rightButtonAction: (()->())?
}

class TwoButtonCell: UITableViewCell {
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    var rowModel: TwoButtonCellRowModel?
    
    override func awakeFromNib() {
        self.setButton(button: self.leftButton)
        self.setButton(button: self.rightButton)
        self.leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
    }
    @objc func leftButtonAction() {
        self.rowModel?.leftButtonAction?()
    }
    @objc func rightButtonAction() {
        self.rowModel?.rightButtonAction?()
    }
    
    func setButton(button: UIButton){
        
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .init(hex: "3472D9")
        
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        
    }
}

extension TwoButtonCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model  as? TwoButtonCellRowModel else { return }
        
        self.rowModel = rowModel
        self.leftButton.setTitle(rowModel.leftTitle, for: .normal)
        self.rightButton.setTitle(rowModel.righttitle, for: .normal)
        
    }
}
