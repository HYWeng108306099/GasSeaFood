
import Foundation
import UIKit

class OrderCellRowModel: CellRowModel {
    init(type: String = "", quantity: String = "", format: String = "", cellDidSelect: ((CellRowModel)->())? = nil) {
        super.init()
        self.cellDidSelect = cellDidSelect
        self.type = type
        self.quantity = quantity
        self.format = format
    }
    
    override func cellReUseID() -> String {
        return "OrderCell"
    }
    
    var type: String = ""
    var quantity: String = ""
    var format: String = ""
    
}

class OrderCell: UITableViewCell {
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var arrowLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var formatLabel: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    override func awakeFromNib() {
        
        self.selectionStyle = .none
        
        insideView.layer.borderColor = UIColor.black.cgColor
        insideView.layer.borderWidth = 1.5
        insideView.layer.cornerRadius = 15
        insideView.clipsToBounds = true
        
        arrowLabel.text = "＞"
        
        arrowLabel.font = .systemFont(ofSize: 26, weight: .bold)
        
        typeLabel.font = .systemFont(ofSize: 26, weight: .bold)
        
        formatLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        quantity.font = .systemFont(ofSize: 20, weight: .bold)
    }
}

extension OrderCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? OrderCellRowModel else { return }
        self.typeLabel.text = rowModel.type
        self.formatLabel.text = "規格：\(rowModel.format)"
        self.quantity.text = "數量：\(rowModel.quantity)"
    }
}
