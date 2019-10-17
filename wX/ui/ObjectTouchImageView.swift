/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTouchImageView {

    var img = ImageScrollView()
    private var uiv: UIViewController?
    var bitmap = Bitmap()

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, hasTopToolbar: Bool = false) {
        self.init()
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        var height = UtilityUI.effectiveHeight(toolbar)
        var y = UtilityUI.getTopPadding()
        if hasTopToolbar {
            y += toolbar.frame.height
            height -= toolbar.frame.height
        }
        img = ImageScrollView(
            frame: CGRect(
                x: 0,
                y: y,
                width: width,
                height: height
            )
        )
        uiv.view.addSubview(img)
        img.contentMode = UIView.ContentMode.scaleAspectFit
        self.img.translatesAutoresizingMaskIntoConstraints = false
        self.img.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        self.img.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: y).isActive = true
        self.img.leftAnchor.constraint(equalTo: uiv.view.leftAnchor).isActive = true
        self.img.rightAnchor.constraint(equalTo: uiv.view.rightAnchor).isActive = true
        self.uiv = uiv
    }

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, _ bitmap: Bitmap) {
        self.init(uiv, toolbar)
        img.display(image: bitmap.image)
        self.uiv = uiv
        self.bitmap = bitmap
    }

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, _ action: Selector, hasTopToolbar: Bool = false) {
        self.init(uiv, toolbar, hasTopToolbar: hasTopToolbar)
        addGestureRecognizer(action)
    }

    func setBitmap(_ bitmap: Bitmap) {
        img.display(image: bitmap.image)
        self.bitmap = bitmap
    }

    func updateBitmap(_ bitmap: Bitmap) {
        img.zoomView?.image = bitmap.image
        self.bitmap = bitmap
    }

    func addGestureRecognizer( _ leftSwipe: UISwipeGestureRecognizer, _ rightSwipe: UISwipeGestureRecognizer) {
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        img.addGestureRecognizer(leftSwipe)
        img.addGestureRecognizer(rightSwipe)
    }

    func addGestureRecognizer(_ action: Selector) {
        let leftSwipe = UISwipeGestureRecognizer(target: uiv, action: action)
        let rightSwipe = UISwipeGestureRecognizer(target: uiv, action: action)
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        img.addGestureRecognizer(leftSwipe)
        img.addGestureRecognizer(rightSwipe)
    }

    func startAnimating(_ animDrawable: AnimationDrawable) {
        self.img.zoomView?.animationImages = animDrawable.imageArray
        self.img.zoomView?.animationDuration = animDrawable.animationDelay
        self.img.zoomView?.startAnimating()
    }

    func setMaxScaleFromMinScale(_ value: CGFloat) {
        img.maxScaleFromMinScale = value
    }

    func setKZoomInFactorFromMinWhenDoubleTap(_ value: CGFloat) {
        img.kZoomInFactorFromMinWhenDoubleTap = value
    }
}
