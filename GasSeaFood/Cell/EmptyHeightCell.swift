

import Foundation
import UIKit

class EmptyHeightRowModel: CellRowModel {
    override func cellReUseID() -> String {
        return "EmptyHeightCell"
    }
    
    var cellHeight: CGFloat = 0
    
    var color: UIColor = .white
    
    var attr: NSAttributedString?
    
    var textAligment: NSTextAlignment = .center
    
    init(
        cellHeight: CGFloat,
        color: UIColor = .white,
        attr: NSAttributedString? = nil,
        textAligment: NSTextAlignment = .center
    ) {
        self.cellHeight = cellHeight
        self.color = color
        self.attr = attr
        self.textAligment = textAligment
    }
}

class EmptyHeightCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var cellViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        titleLabel.numberOfLines = 0
        self.selectionStyle = .none
    }
    
}

extension EmptyHeightCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? EmptyHeightRowModel else { return }
        
        self.cellViewHeight.constant = rowModel.cellHeight
        self.backView.backgroundColor = rowModel.color
        
        self.titleLabel.textAlignment = rowModel.textAligment
        
        if let attr = rowModel.attr {
            self.titleLabel.attributedText = attr
            self.titleLabel.isHidden = false
        } else {
            self.titleLabel.isHidden = true
        }
        
    }
}
