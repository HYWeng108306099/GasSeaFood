

import Foundation
import UIKit

class ActionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(
        action: (()->())?
    ){
        self.init(frame: .zero)
        self.action = action
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    var action: (()->())?
    
    @objc func tapAction() {
        self.action?()
    }
    
}
