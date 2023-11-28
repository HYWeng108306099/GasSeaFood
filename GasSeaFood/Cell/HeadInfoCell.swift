
import Foundation
import UIKit


class HeadInfoRowModel: CellRowModel {
    
    override func cellReUseID() -> String {
        return "HeadInfoCell"
    }
    
    var name: String?
    
    var infoAction: (()->())?
    
    var logoutAcction: (()->())?
    
    init(name: String? = nil, infoAction: (() -> ())? = nil, logoutAcction: (() -> ())? = nil) {
        self.name = name
        self.infoAction = infoAction
        self.logoutAcction = logoutAcction
    }
    
}

class HeadInfoCell: UITableViewCell {
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    var rowModel: HeadInfoRowModel?
    
    override func awakeFromNib() {
        self.headImageView.layer.cornerRadius = 40
        self.headImageView.image = UIImage(named: "head")?.resizeImage(targetSize: .init(width: 80, height: 80))
        
        self.nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        self.logoutButton.setTitle("登出", for: .normal)
        self.logoutButton.setTitleColor(.init(hex: "3472D9"), for: .normal)
        self.logoutButton.layer.borderWidth = 1
        self.logoutButton.layer.cornerRadius = 10
        self.logoutButton.layer.borderColor = UIColor.init(hex: "3472D9").cgColor
        self.logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        
        self.infoButton.setTitle("編輯個人檔案", for: .normal)
        self.infoButton.setTitleColor(.init(hex: "3472D9"), for: .normal)
        self.infoButton.layer.borderWidth = 1
        self.infoButton.layer.cornerRadius = 10
        self.infoButton.layer.borderColor = UIColor.init(hex: "3472D9").cgColor
        self.infoButton.addTarget(self, action: #selector(infoAction), for: .touchUpInside)
        
        self.nameLabel.numberOfLines = 1
        self.nameLabel.lineBreakMode = .byTruncatingMiddle
    }
    
    @objc func logoutAction() {
        self.rowModel?.logoutAcction?()
    }
    
    @objc func infoAction() {
        self.rowModel?.infoAction?()
    }
    
    
    
    
}

extension HeadInfoCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? HeadInfoRowModel else { return }
        
        self.rowModel = rowModel
        self.nameLabel.text = rowModel.name
        
    }
}
