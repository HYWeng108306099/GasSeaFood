

import Foundation
import UIKit
import AudioToolbox
import AVFoundation

enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}
extension UIView {
    
    public func drawSingleSideBoder(top: Bool = false, bottom: Bool = false, left: Bool = false, right: Bool = false, width: CGFloat, borderColor: UIColor){
        if top {
            let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            self.draw(rect)
        }
        
        if bottom {
            let rect = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
            self.draw(rect)
            
        }
        
        if left {
            let rect = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            self.draw(rect)
            
        }
        
        if right {
            let rect = CGRect(x: self.frame.size.width - width, y:0 , width: width, height: self.frame.size.height)
            self.draw(rect)
        }
        
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIImageView {
    
    func setImageFromURL(urlText: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlText) else { return }
            let request = URLRequest(url: url, timeoutInterval: 30)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, respond, error in
                if let data = data , let image = UIImage(data: data) {
                    self?.image = image
                }
            }
        }
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let cgImage = image?.cgImage else { return nil }
      self.init(cgImage: cgImage)
    }
    
    func resize(targetSize: CGSize, isAspect: Bool = true) -> UIImage {
        var newSize: CGSize = targetSize
        if isAspect {
            // Figure out what our orientation is, and use that to form the rectangle
            let widthRatio  = targetSize.width  / self.size.width
            let heightRatio = targetSize.height / self.size.height
            
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 10.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
extension NSObject {
    
    func systemVibration(sender: AnyObject, complete: (()->())?) {
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), complete)
    }
    
    func sendLocalNotication(title: String? = nil, subTitle: String? = nil, body: String? = nil) {
        
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.subtitle = subTitle ?? ""
        content.body = body ?? ""
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
        }
    }
}
