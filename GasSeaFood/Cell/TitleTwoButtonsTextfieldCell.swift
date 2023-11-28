

import Foundation
import UIKit

class TitleTwoButtonsTextfieldRowModel: CellRowModel {
    override func cellReUseID() -> String {
        return "TitleTwoButtonsTextfieldCell"
    }
    
    var title: String?
    
    var country: String?
    
    var area: String?
    
    var textDidChange: ((String)->())?
    
    init(title: String? = nil, country: String? = nil, area: String? = nil, textDidChange: ( (String) -> ())? = nil) {
        self.title = title
        self.country = country
        self.area = area
        self.textDidChange = textDidChange
    }
    
}

class TitleTwoButtonsTextfieldCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var areaButton: UIButton!
    
    @IBOutlet weak var contentTextField: UITextField!
    
    var rowModel: TitleTwoButtonsTextfieldRowModel?
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        self.contentTextField.addTarget(self, action: #selector(textFieldDidEdit(_:)), for: .valueChanged)
        
        self.titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        if #available(iOS 15.0, *) {
            self.countryButton.configuration = nil
        }
        
        self.countryButton.setTitleColor(.white, for: .normal)
        self.countryButton.backgroundColor = .init(hex: "3472D9")
        self.countryButton.semanticContentAttribute = .forceRightToLeft
        self.countryButton.setImage(UIImage(named: "traingle")?.resizeImage(targetSize: .init(width: 15, height: 15)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.countryButton.tintColor = .white
        self.countryButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        self.countryButton.titleLabel?.textAlignment = .left
        self.countryButton.layer.cornerRadius = 8
        self.countryButton.showsMenuAsPrimaryAction = true
        self.defaultSet()
        
        if #available(iOS 15.0, *) {
            self.areaButton.configuration = nil
        }
        self.areaButton.setTitleColor(.white, for: .normal)
        self.areaButton.backgroundColor = .init(hex: "3472D9")
        self.areaButton.semanticContentAttribute = .forceRightToLeft
        self.areaButton.setImage(UIImage(named: "traingle")?.resizeImage(targetSize: .init(width: 15, height: 15)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.areaButton.tintColor = .white
        self.areaButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        self.areaButton.titleLabel?.textAlignment = .left
        self.areaButton.layer.cornerRadius = 8
        self.areaButton.showsMenuAsPrimaryAction = true


    }
    
    func setCountryButtonTitle(title: String) {
        self.countryButton.setTitle(title + "   ", for: .normal)
        self.rowModel?.country = title
    }
    

    func setAreaButtonTitle(title: String) {
        self.areaButton.setTitle(title + "   ", for: .normal)
        self.rowModel?.area = title
    }
    

    
    @objc func textFieldDidEdit(_ sender: UITextField) {
        let text = (self.rowModel?.country ?? "") + (self.rowModel?.area ?? "") + (sender.text ?? "")
        self.rowModel?.textDidChange?(text)
    }
    
    func defaultSet() {
        
        let countrys = CityCenter.share.countrys

        var actions: [UIAction] = []
        
        for country in countrys {
            let action = UIAction(title: country.country_name ?? "" , handler: {  [weak self] action in
                self?.setCountryButtonTitle(title: action.title)
                self?.setAreaButton(country: country)

            })
            
            actions.append(action)
        }
        
        self.countryButton.menu = .init(children: actions)
        
    }
    
    func setAreaButton(country: CountryModel) {
        let city = CityCenter.share.citys.filter({$0.country_id == country.country_id ?? ""})
        self.areaButton.menu = .init(children: city.map({UIAction(title: $0.city_name ?? "") { [weak self] action in
            self?.setAreaButtonTitle(title: action.title)
        }}))
    }
    
}

extension TitleTwoButtonsTextfieldCell: BaseCellView {
    func setupCellView(model: BaseCellModel) {
        guard let rowModel = model as? TitleTwoButtonsTextfieldRowModel else { return }
        self.rowModel = rowModel
        self.titleLabel.text = rowModel.title
        self.countryButton.setTitle((rowModel.country ?? "") + "   ", for: .normal)
        self.areaButton.setTitle((rowModel.area ?? "") + "   ", for: .normal)
        
    }
}
