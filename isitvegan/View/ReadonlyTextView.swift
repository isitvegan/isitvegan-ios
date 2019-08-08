import UIKit

class ReadonlyTextView: UITextView {
    init() {
        super.init(frame: .zero, textContainer: nil)
        isSelectable = true
        isScrollEnabled = false
        isEditable = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
