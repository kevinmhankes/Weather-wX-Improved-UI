/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImage {

    let img = UIImageView()
    private var width: CGFloat = 0.0
    private var widthDivider = 1
    var bitmap = Bitmap()

    init() {
        img.contentMode = UIView.ContentMode.scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        (width, _) = UtilityUI.getScreenBoundsCGFloat()
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, widthDivider: Int = 1) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        self.widthDivider = widthDivider
        setImageAnchors(width / CGFloat(widthDivider) - UIPreferences.stackviewCardSpacing)
        stackView.addArrangedSubview(img)
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, _ gesture: UITapGestureRecognizer, widthDivider: Int = 1) {
        self.init(stackView, bitmap, widthDivider: widthDivider)
        addGestureRecognizer(gesture)
    }

    convenience init(_ scrollView: UIScrollView, _ stackView: UIStackView, _ bitmap: Bitmap, hs: Bool) {
        self.init()
        img.image = bitmap.image
        self.bitmap = bitmap
        stackView.addArrangedSubview(img)
        if hs {
            setImageAnchorsForHomeScreen(scrollView)
        } else {
            setImageAnchors(width - UIPreferences.stackviewCardSpacing * 2.0)
        }
    }

    convenience init(_ stackView: UIStackView) {
        self.init()
        stackView.addArrangedSubview(img)
    }

    func setBitmap(_ bitmap: Bitmap) {
        self.bitmap = bitmap
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        setImageAnchors(width)
    }
    
    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        img.addGestureRecognizer(gesture)
    }
    
    private func setImageAnchors(_ width: CGFloat) {
        img.widthAnchor.constraint(equalToConstant: width).isActive = true
        img.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width)).isActive = true
    }
    
    private func setImageAnchorsForHomeScreen(_ scrollView: UIScrollView) {
        img.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        img.heightAnchor.constraint(equalTo: img.widthAnchor, multiplier: (bitmap.height / bitmap.width)).isActive = true
    }
    
    var isHidden: Bool {
        get { img.isHidden }
        set { img.isHidden = newValue }
    }

    var accessibilityLabel: String {
        get { img.accessibilityLabel ?? "" }
        set { img.accessibilityLabel = newValue }
    }
    
    var isAccessibilityElement: Bool {
        get { img.isAccessibilityElement }
        set { img.isAccessibilityElement = newValue }
    }
}
