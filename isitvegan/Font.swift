import UIKit

extension UIFont {
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    private func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let keepSizeAsIs: CGFloat = 0.0
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: keepSizeAsIs)
    }
}
