/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UIColorLegend: UIView {

    private var product = ""
    private var frameSize = CGRect()
    private var context = UIGraphicsGetCurrentContext()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    required init(_ product: String, _ size: CGRect) {
        self.product = product
        frameSize = size
        super.init(frame: size)
        backgroundColor = UIColor.clear
        isOpaque = false
    }

    required init() {
        super.init(frame: CGRect())
    }

    func drawRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        context!.addRect(CGRect(x: x, y: y, width: width, height: height))
        context!.fillPath()
    }

    func drawText(_ string: String, _ x: CGFloat, _ y: CGFloat) {
        let textAttributes = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white.cgColor,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 15)
            ] as [NSAttributedStringKey: Any]?
        let strn = NSString(string: string)
        drawTextString(context!, strn, textAttributes, x, y)
    }

    func drawTextString(_ context: CGContext,
                        _ text: NSString,
                        _ attributes: [NSAttributedStringKey: Any]?,
                        _ x: CGFloat,
                        _ y: CGFloat) {
        let textTransform = CGAffineTransform.init(scaleX: 1.0, y: -1.0)
        context.textMatrix = textTransform
        if let font = attributes![NSAttributedStringKey.font] as? UIFont {
            let attributedString = NSAttributedString(string: text as String, attributes: attributes)
            let textSize = text.size(withAttributes: attributes)
            let textPath = CGPath(rect: CGRect(x: x,
                                               y: y + font.descender,
                                               width: ceil(textSize.width),
                                               height: ceil(textSize.height)), transform: nil)
            let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
            let frame = CTFramesetterCreateFrame(frameSetter,
                                                 CFRange(location: 0, length: attributedString.length), textPath, nil)
            CTFrameDraw(frame, context)
        }
    }

    func setColor(_ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        _ =  wXColor.uiColorInt(red, green, blue).set()
    }

    func setColorWithBuffers(prodId: Int, index: Int) {
        setColor(MyApplication.colorMap[prodId]!.redValues.get(index),
                 MyApplication.colorMap[prodId]!.greenValues.get(index),
                 MyApplication.colorMap[prodId]!.blueValues.get(index))
    }

    override func draw(_ rect: CGRect) {
        var units = ""
        context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(5.0)
        let startHeight: CGFloat = 0.0
        let width: CGFloat = 25.0
        let widthStarting: CGFloat = 0.0
        let textFromLegend: CGFloat = 10.0
        let heightFudge: CGFloat = 15.0
        let screenHeight = self.frame.height
        var scaledHeight = (screenHeight - 2.0 * startHeight)/256.0
        let scaledHeightText = (screenHeight - 2.0 * startHeight)/(95.0+32.0)
        let scaledHeightVel = (screenHeight - 2.0 * startHeight)/(127.0*2.0)
        var unitsDrawn = false
        switch product {
        case "N0Q", "L2REF", "TZL":
            (0...255).forEach {
                setColorWithBuffers(prodId: 94, index: 255 - $0)
                drawRect(widthStarting, CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting, CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " dBZ"
            (1...95).reversed().forEach {
                if $0 % 10 == 0 {
                    drawText(String($0) + units,
                             widthStarting + width + textFromLegend,
                             (scaledHeightText * (CGFloat(95) - CGFloat($0))) + heightFudge + startHeight)
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "N0U", "L2VEL", "TV0":
            (0...255).forEach {
                setColorWithBuffers(prodId: 99, index: 255 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting, CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " KT"
            (-131...122).reversed().forEach {
                if $0 % 10 == 0 {
                    drawText(String($0) + units,
                             widthStarting + width + textFromLegend,
                             (scaledHeightVel * (122.0 - CGFloat($0))) + heightFudge + startHeight)
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "DVL":
            (0...255).forEach {
                setColorWithBuffers(prodId: 134, index: 255 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting,
                         CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " kg/m2"
            (1...70).reversed().forEach {
                if $0 % 5 == 0 {
                    drawText(String($0) + units,
                             widthStarting + width + textFromLegend,
                             (3.64 * scaledHeightVel * (CGFloat(70) - CGFloat($0))) + heightFudge + startHeight)
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "EET":
            scaledHeight =  (screenHeight-2.0*startHeight)/70.0
            (0...70).forEach {
                setColorWithBuffers(prodId: 135, index: 70 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting, CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " K FT"
            (1...70).reversed().forEach {
                if $0 % 5 == 0 {
                    drawText(String($0) + units,
                             widthStarting + width + textFromLegend,
                             (3.64 * scaledHeightVel * (CGFloat(70) - CGFloat($0))) + heightFudge + startHeight)
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "N0X":
            for i in (0..<256) {
                setColorWithBuffers(prodId: 159, index: 255 - i)
                drawRect(widthStarting,
                         CGFloat(i) * scaledHeight + startHeight,
                         width + widthStarting, CGFloat(i) * scaledHeight + scaledHeight + startHeight)
            }
            units = " dB"
            (-7...8).reversed().forEach {
                drawText( String($0) + units,
                          widthStarting + width + textFromLegend,
                          (16 * scaledHeightVel * (CGFloat(8) - CGFloat($0))) + heightFudge + startHeight)
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
            }
        case "N0C":
            (0...255).forEach {
                setColorWithBuffers(prodId: 161, index: 255 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting,
                         CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " CC"
            (0...100).reversed().forEach {
                if $0 % 5 == 0 {
                    let tmpStr = String(Double($0)/100.0).truncate(4)
                    drawText(tmpStr + units,
                             widthStarting + width + textFromLegend,
                             (CGFloat(3)*scaledHeightVel*CGFloat(100 - $0)) + heightFudge + startHeight)
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "N0K":
            (0...255).forEach {
                setColorWithBuffers(prodId: 163, index: 255 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting,
                         CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " PHAS"
            for j in ( -2...10 ).reversed() {
                drawText(String(j) + units,
                         widthStarting + width + textFromLegend,
                         (20.0 * scaledHeightVel * (10.0 - CGFloat(j))) + heightFudge + startHeight)
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
            }
        case "H0C":
            scaledHeight = (screenHeight - 2.0 * startHeight)/160.0
            var labels = ["ND", "BI", "GC", "IC", "DS", "WS", "RA", "HR", "BD", "GR", "HA", "", "", "", "UK", "RF"]
            (0...159).forEach {
                setColorWithBuffers(prodId: 165, index: 160 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting,
                         CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = ""
            (0...159).reversed().forEach {
                if $0 % 10 == 0 {
                    drawText(labels[Int($0/10)] + units,
                             widthStarting + width + textFromLegend,
                             (scaledHeight * (159.0 - CGFloat($0)))  + startHeight)
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "DSP":
            (0...255).forEach {
                setColorWithBuffers(prodId: 172, index: 255 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting,
                         CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " IN"
            var j = ActVars.WXOGLDspLegendMax
            while j > 0 {
                let xVar = widthStarting + width + textFromLegend
                let yVar1 = CGFloat(255.0/ActVars.WXOGLDspLegendMax)
                    * scaledHeightVel
                    * CGFloat(ActVars.WXOGLDspLegendMax - j)
                let yVar = yVar1 + heightFudge + startHeight
                drawText(String(j).truncate(4) + units, xVar, yVar)
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
                j -= ActVars.WXOGLDspLegendMax/16.0
            }
        case "DAA":
            (0...255).forEach {
                setColorWithBuffers(prodId: 172, index: 255 - $0)
                drawRect(widthStarting,
                         CGFloat($0) * scaledHeight + startHeight,
                         width + widthStarting,
                         CGFloat($0) * scaledHeight + scaledHeight + startHeight)
            }
            units = " IN"
            var j = ActVars.WXOGLDspLegendMax
            while j > 0 {
                let xVar = widthStarting + width + textFromLegend
                let yVar1 = CGFloat(255.0/ActVars.WXOGLDspLegendMax)
                    * scaledHeightVel
                    * CGFloat(ActVars.WXOGLDspLegendMax - j)
                let yVar = yVar1 + heightFudge + startHeight
                drawText(String(j).truncate(4) + units, xVar, yVar)
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
                j -= ActVars.WXOGLDspLegendMax/16.0
            }
        default: break
        }
    }
}
