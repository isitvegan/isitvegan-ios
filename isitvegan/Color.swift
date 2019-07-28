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

    class var label: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }

    class var secondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .lightGray
        }
    }

    class var separator: UIColor {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return .init(red: 0.23529411764705882,
                         green: 0.23529411764705882,
                         blue: 0.2627450980392157,
                         alpha: 0.29)
        }
    }
}
