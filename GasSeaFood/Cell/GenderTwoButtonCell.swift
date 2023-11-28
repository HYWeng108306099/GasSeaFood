

import Foundation
import UIKit


class GenderTwoButtonRowModel: CellRowModel {
    override func cellReUseID() -> String {
        return "GenderTwoButtonCell"
    }
    
    var buttonAction: ((String)->())?
    init(buttonAction: ( (String) -> ())? = nil) {
        self.buttonAction = buttonAction
    }
}

class GenderTwoButtonCell: UITableViewCell {
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var rowModel: GenderTwoButtonRowModel?
    
    override func awakeFromNib() {
        

        
        self.maleButton.setTitle("男", for: .normal)
        if #available(iOS 15.0, *) {
            self.maleButton.configuration = nil
        }
        self.maleButton.setTitleColor(.black, for: .normal)
        self.maleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        self.maleButton.setImage(UIImage(named: "uncheck")?.resizeImage(targetSize: .init(width: 20, height: 20)), for: .normal)
        self.maleButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        

        if #available(iOS 15.0, *) {
            self.femaleButton.configuration = nil
        }
        self.femaleButton.setTitleColor(.black, for: .normal)
        self.femaleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        self.femaleButton.setTitle("女", for: .normal)
        self.femaleButton.setImage(UIImage(named: "uncheck")?.resizeImage(targetSize: .init(width: 20, height: 20)), for: .normal)
        self.femaleButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    
    func resetButton() {
        self.maleButton.isSelected = false
        self.femaleButton.isSelected = false
        
        self.maleButton.imageView?.backgroundColor = .clear
        self.femaleButton.imageView?.backgroundColor = .clear
        
        self.maleButton.imageView?.layer.cornerRadius = (self.maleButton.imageView?.frame.height ?? 0) / 2
        self.femaleButton.imageView?.layer.cornerRadius = (self.femaleButton.imageView?.frame.height ?? 0) / 2
        
        self.maleButton.imageView?.layer.borderWidth = 2
        self.femaleButton.imageView?.layer.borderWidth = 2
        
        self.maleButton.imageView?.layer.borderColor = UIColor.black.cgColor
        self.femaleButton.imageView?.layer.borderColor = UIColor.black.cgColor

    }
    
    @objc func buttonAction(_ sender: UIButton) {
        self.resetButton()
        sender.isSelected = true
        sender.imageView?.backgroundColor = .init(hex: "3472D9")
        self.rowModel?.buttonAction?(sender.titleLabel?.text ?? "")
    }
    
}

extension GenderTwoButtonCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? GenderTwoButtonRowModel else { return }
        self.rowModel = rowModel
        self.resetButton()
    }
}
