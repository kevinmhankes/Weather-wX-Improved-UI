/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UILabelInset: UILabel {

    private let topInset: CGFloat = 0
    private let bottomInset: CGFloat = 0
    private let leftInset: CGFloat = 5
    private let rightInset: CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        //super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
