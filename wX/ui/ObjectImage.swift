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
//    var stackView: UIStackView
    
//    var anchor1: NSLayoutConstraint?
//    var anchor2: NSLayoutConstraint?

    init() {
        img.contentMode = UIView.ContentMode.scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        (width, _) = UtilityUI.getScreenBoundsCGFloat()
//        self.stackView = UIStackView()
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, widthDivider: Int = 1) {
        self.init()
//        self.stackView = stackView
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

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, viewOrder: Int) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        setImageAnchors(width)
        stackView.insertArrangedSubview(img, at: viewOrder)
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
    
    func changeWidth() {
        (width, _) = UtilityUI.getScreenBoundsCGFloat()
        setImageAnchors(width / CGFloat(widthDivider) - UIPreferences.stackviewCardSpacing)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        img.addGestureRecognizer(gesture)
    }

    private func setImageAnchors(_ width: CGFloat) {
        img.widthAnchor.constraint(equalToConstant: width).isActive = true
        img.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width)).isActive = true
        
//        anchor1 = img.widthAnchor.constraint(equalToConstant: width)
//        anchor2 = img.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width))
//        stackView.addConstraints([anchor1!, anchor2!])
    }
    
    private func setImageAnchorsForHomeScreen(_ scrollView: UIScrollView) {
        img.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        img.heightAnchor.constraint(equalTo: img.widthAnchor, multiplier: (bitmap.height / bitmap.width)).isActive = true
    }
}
