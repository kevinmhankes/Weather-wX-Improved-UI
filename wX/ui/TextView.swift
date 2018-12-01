/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import OpenGLES
import GLKit

final class TextView {

    private var context: GLKViewController
    private var realTextSize = 0.0
    var textColor = 0
    private var text = ""
    private var xPos: CGFloat = 0.0
    private var yPos: CGFloat = 0.0
    private var tv = UITextView()
    private var width: CGFloat = 150
    private var height: CGFloat = 40

    init(_ context: GLKViewController, _ width: Int = 150, _ height: Int = 40) {
        self.context = context
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }

    var textSize: Double {
        get {return self.realTextSize / 13.0}
        set {self.realTextSize = newValue * 13.0}
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
        tv = UITextView(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        tv.text = string
        tv.font = UIFont.systemFont(ofSize: CGFloat(self.realTextSize))
        tv.backgroundColor = UIColor.clear
        tv.textColor = wXColor(textColor).uicolorCurrent
        tv.textContainer.lineBreakMode = .byTruncatingTail
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        context.view.addSubview(tv)
    }
}
