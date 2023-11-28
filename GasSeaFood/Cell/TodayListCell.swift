

import Foundation
import UIKit

class TodayListCellRowModel: CellRowModel {
    override func cellReUseID() -> String {
        return "TodayListCell"
    }
    
    var title: String?
    
    var titleLabelAction: (()->())? = nil
    
    init(title: String? = nil, titleLabelAction: (()->())? = nil) {
        super.init()
        self.title = title
        self.titleLabelAction = titleLabelAction
    }
}

class TodayListCell: UITableViewCell {
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var rowModel: TodayListCellRowModel?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelAction))
        
        self.titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        self.titleLabel.isUserInteractionEnabled = true
        self.titleLabel.addGestureRecognizer(tap)
        
        self.insideView.layer.cornerRadius = 5
        self.insideView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.insideView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.insideView.layer.shadowOpacity = 1.0
        self.insideView.layer.shadowRadius = 5.0

    }
    
    @objc func labelAction() {
        self.rowModel?.titleLabelAction?()
    }
    
}

extension TodayListCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? TodayListCellRowModel else { return }
        self.rowModel = rowModel
        self.titleLabel.text = rowModel.title
    }
}
