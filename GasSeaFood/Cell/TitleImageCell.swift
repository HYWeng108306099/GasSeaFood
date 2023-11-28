
import Foundation
import UIKit

class TitleImageRowModel: CellRowModel {
    
    override func cellReUseID() -> String {
        return "TitleImageCell"
    }
    
    var title: String?
    
    var imageName: String?
    
    init(title: String? = nil, imageName: String? = nil) {
        self.title = title
        self.imageName = imageName
    }
    
}

class TitleImageCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        self.centerImageView.layer.cornerRadius = 80
    }
    
}

extension TitleImageCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? TitleImageRowModel else { return }
        self.titleLabel.text = rowModel.title
        self.centerImageView.image = UIImage(named: rowModel.imageName ?? "")?.resizeImage(targetSize: .init(width: 120, height: 120)).withRenderingMode(.alwaysTemplate)
        self.centerImageView.tintColor = .white
    }
}
