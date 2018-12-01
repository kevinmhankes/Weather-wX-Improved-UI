import UIKit

final class StackView: UIStackView {

    private var color: UIColor?

    override var backgroundColor: UIColor? {
        get { return color }
        set { color = newValue }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
