

import Foundation
import UIKit

class TitleTextFieldRowModel: CellRowModel {
    
    override func cellReUseID() -> String {
        return "TitleTextFieldCell"
    }
    
    var title: String?
    
    var text: String?
    
    var textDidChange: ((String)->())?
    
    var placeHolder: String?
    
    var required: Bool = true
    
    var canEdit: Bool = true
    
    init(title: String? = nil, text: String? = nil, placeHolder: String? = nil, required: Bool = true,canEdit: Bool = true, textDidChange: ((String) -> ())? = nil) {
        self.title = title
        self.text = text
        self.placeHolder = placeHolder
        self.required = required
        self.canEdit = canEdit
        self.textDidChange = textDidChange
    }
    
}

class TitleTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBOutlet weak var requiredLabel: UILabel!
    
    var rowModel: TitleTextFieldRowModel?

    override func awakeFromNib() {
        self.selectionStyle = .none
        self.contentTextField.addTarget(self, action: #selector(textFieldDidEdit(_:)), for: .editingChanged)
        
        self.titleLabel.font = .systemFont(ofSize: 16,weight: .bold)
        
        self.requiredLabel.font = .systemFont(ofSize: 12)
        self.requiredLabel.text = "(非必填)"
    }
    
    @objc func textFieldDidEdit(_ sender: UITextField) {
        self.rowModel?.textDidChange?(sender.text ?? "")
    }
    
}


extension TitleTextFieldCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? TitleTextFieldRowModel else { return }
        self.rowModel = rowModel
        self.titleLabel.text = rowModel.title
        self.requiredLabel.isHidden = rowModel.required
        self.contentTextField.isUserInteractionEnabled = rowModel.canEdit
        
        
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        if let placeHolder = rowModel.placeHolder {
            self.contentTextField.attributedPlaceholder = NSAttributedString(
                string: placeHolder,
                attributes: [.paragraphStyle: centeredParagraphStyle]
            )
        }
    
        if let text = rowModel.text {
            self.contentTextField.text = text
        }

    }
}
