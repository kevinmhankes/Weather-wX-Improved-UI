import UIKit

final class StackView: UIStackView {

    private var color: UIColor?

    override var backgroundColor: UIColor? {
        get { color }
        set { color = newValue }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: bounds).cgPath
        backgroundLayer.fillColor = backgroundColor?.cgColor
    }
    
//    func addWidget(_ view: UIView) {
//        addArrangedSubview(view)
//    }
}
