import UIKit

extension UIColor {
    class var veganGreen: UIColor {
        return UIColor(named: "veganGreen")!
    }
}

class Color {
    class var systemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}
