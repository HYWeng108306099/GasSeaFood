

import Foundation
import UIKit

class LabelCellRowModel: CellRowModel {
    override func cellReUseID() -> String {
        return "LabelCell"
    }
    var titleAttr: NSAttributedString?
    
    var needImage: Bool = false
    
    var labelTapAction: (()->())?
    
    init(titleAttr: NSAttributedString? = nil, needImage: Bool = false, labelTapAction: (() -> ())? = nil) {
        self.titleAttr = titleAttr
        self.needImage = needImage
        self.labelTapAction = labelTapAction
    }
}

class LabelCell: UITableViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var rowModel: LabelCellRowModel?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapAction))
        tap.numberOfTapsRequired = 1
        
        self.titleLabel.addGestureRecognizer(tap)
        self.titleLabel.isUserInteractionEnabled = true
        self.titleLabel.textAlignment = .center
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(labelTapAction))
        tap1.numberOfTapsRequired = 1
        self.checkImageView.image = UIImage(named: "uncheck")?.resizeImage(targetSize: .init(width: 20, height: 20))
        self.checkImageView.addGestureRecognizer(tap1)
        self.checkImageView.isUserInteractionEnabled = true
        self.checkImageView.layer.borderWidth = 2
        self.checkImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func labelTapAction() {
        
        if self.rowModel?.needImage ?? false {
            self.checkImageView.isHighlighted.toggle()
            self.checkImageView.backgroundColor = self.checkImageView.isHighlighted ? .init(hex: "3472D9") : .clear
        }
        
        self.rowModel?.labelTapAction?()
    }

}

extension LabelCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? LabelCellRowModel else { return }
        self.rowModel = rowModel
        self.checkImageView.isHidden = !rowModel.needImage
        self.titleLabel.attributedText = rowModel.titleAttr
        self.checkImageView.layer.cornerRadius = 10
        self.checkImageView.image
        
    }
}
