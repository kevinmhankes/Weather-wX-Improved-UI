/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class TouchImage {

    var img = ImageScrollView()
    private var uiv: UIViewController?
    var bitmap = Bitmap()

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, hasTopToolbar: Bool = false, topToolbar: UIToolbar = UIToolbar()) {
        self.init()
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        let height = UtilityUI.effectiveHeight(toolbar)
        let y = UtilityUI.getTopPadding()
        img = ImageScrollView(frame: CGRect(x: 0, y: y, width: width, height: height))
        uiv.view.addSubview(img)
        img.contentMode = UIView.ContentMode.scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        if !hasTopToolbar {
            img.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: y).isActive = true
        } else {
            img.topAnchor.constraint(equalTo: topToolbar.bottomAnchor).isActive = true
        }
        img.leftAnchor.constraint(equalTo: uiv.view.leftAnchor).isActive = true
        img.rightAnchor.constraint(equalTo: uiv.view.rightAnchor).isActive = true
        self.uiv = uiv
    }

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, _ bitmap: Bitmap) {
        self.init(uiv, toolbar)
        img.display(image: bitmap.image)
        self.uiv = uiv
        self.bitmap = bitmap
    }

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, _ action: Selector, hasTopToolbar: Bool = false, topToolbar: UIToolbar = UIToolbar()) {
        self.init(uiv, toolbar, hasTopToolbar: hasTopToolbar, topToolbar: topToolbar)
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

    func refresh() {
        img.refresh()
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
        img.zoomView?.animationImages = animDrawable.images
        img.zoomView?.animationDuration = animDrawable.animationDelay
        img.zoomView?.startAnimating()
    }
    
    func stopAnimating() {
        img.zoomView?.stopAnimating()
    }
    
    func isAnimating() -> Bool {
        img.zoomView?.isAnimating ?? false
    }

    func setMaxScaleFromMinScale(_ value: CGFloat) {
        img.maxScaleFromMinScale = value
    }

    func setKZoomInFactorFromMinWhenDoubleTap(_ value: CGFloat) {
        img.kZoomInFactorFromMinWhenDoubleTap = value
    }
}
