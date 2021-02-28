/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class TextViewMetal {

    private var uiv: UIViewController
    private var realTextSize = 0.0
    var textColor = 0
    private var text = ""
    private var xPos: CGFloat = 0.0
    private var yPos: CGFloat = 0.0
    private let width: CGFloat
    private let height: CGFloat

    init(_ uiv: UIViewController, _ width: Int = 150, _ height: Int = 40) {
        self.uiv = uiv
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }

    var textSize: Double {
        get { realTextSize / 13.0 }
        set { realTextSize = newValue * 13.0 }
    }

    func setText(_ text: String) {
        self.text = text
        drawText(text, xPos, yPos)
    }

    func setPadding(_ xPos: CGFloat, _ yPos: CGFloat) {
        self.xPos = xPos
        self.yPos = yPos
    }

    func drawText(_ string: String, _ xPos: CGFloat, _ yPos: CGFloat) {
        let uiTextView = UITextView(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        uiTextView.text = string
        uiTextView.font = UIFont.systemFont(ofSize: CGFloat(realTextSize))
        uiTextView.backgroundColor = UIColor.clear
        uiTextView.textColor = wXColor(textColor).uiColorCurrent
        uiTextView.textContainer.lineBreakMode = .byTruncatingTail
        uiTextView.isEditable = false
        uiTextView.isUserInteractionEnabled = false
        uiv.view.addSubview(uiTextView)
    }
}
