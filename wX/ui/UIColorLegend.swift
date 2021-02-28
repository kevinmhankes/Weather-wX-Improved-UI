/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
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
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white.cgColor,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): FontSize.small.size
            ] as [NSAttributedString.Key: Any]?
        let strn = NSString(string: string)
        drawTextString(context!, strn, textAttributes, x, y)
    }
    
    func drawTextString(
        _ context: CGContext,
        _ text: NSString,
        _ attributes: [NSAttributedString.Key: Any]?,
        _ x: CGFloat,
        _ y: CGFloat
    ) {
//        print(x)
//        print(y)
        let textTransform = CGAffineTransform.init(scaleX: 1.0, y: -1.0)
        context.textMatrix = textTransform
        if let font = attributes![NSAttributedString.Key.font] as? UIFont {
            let attributedString = NSAttributedString(string: text as String, attributes: attributes)
            
            //let attributedString = NSMutableAttributedString(string: text as String, attributes: attributes)
            //let range = (text as NSString).range(of: text as String)
            //attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
            
            let textSize = text.size(withAttributes: attributes)
            let textPath = CGPath(
                rect: CGRect(
                    x: x,
                    y: y + font.descender,
                    width: ceil(textSize.width),
                    height: ceil(textSize.height)
                ),
                transform: nil
            )
            let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
            let frame = CTFramesetterCreateFrame(
                frameSetter,
                CFRange(location: 0, length: attributedString.length), textPath, nil
            )
            CTFrameDraw(frame, context)
        }
    }
    
    func setColor(_ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        wXColor.uiColorInt(red, green, blue).set()
    }
    
    func setColorWithBuffers(prodId: Int, index: Int) {
        setColor(
            ObjectColorPalette.colorMap[prodId]!.redValues.get(index),
            ObjectColorPalette.colorMap[prodId]!.greenValues.get(index),
            ObjectColorPalette.colorMap[prodId]!.blueValues.get(index)
        )
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
        let screenHeight = frame.height
        var scaledHeight = (screenHeight - 2.0 * startHeight) / 256.0
        let scaledHeightText = (screenHeight - 2.0 * startHeight) / (95.0 + 32.0)
        let scaledHeightVel = (screenHeight - 2.0 * startHeight) / (127.0 * 2.0)
        var unitsDrawn = false
        switch product {
        case "N0Q", "L2REF", "TZL":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 94, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " dBZ"
            (1...95).reversed().forEach { index in
                if index % 10 == 0 {
                    drawText(
                        String(index) + units,
                        widthStarting + width + textFromLegend,
                        (scaledHeightText * (CGFloat(95) - CGFloat(index))) + heightFudge + startHeight
                    )
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "N0U", "L2VEL", "TV0":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 99, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " KT"
            (-131...122).reversed().forEach { index in
                if index % 10 == 0 {
                    drawText(
                        String(index) + units,
                        widthStarting + width + textFromLegend,
                        (scaledHeightVel * (122.0 - CGFloat(index))) + heightFudge + startHeight
                    )
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "DVL":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 134, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " kg/m2"
            (1...70).reversed().forEach { index in
                if index % 5 == 0 {
                    drawText(
                        String(index) + units,
                        widthStarting + width + textFromLegend,
                        (3.64 * scaledHeightVel * (CGFloat(70) - CGFloat(index))) + heightFudge + startHeight
                    )
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "EET":
            scaledHeight = (screenHeight - 2.0 * startHeight) / 70.0
            (0...70).forEach { index in
                setColorWithBuffers(prodId: 135, index: 70 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting, CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " K FT"
            (1...70).reversed().forEach { index in
                if index % 5 == 0 {
                    drawText(
                        String(index) + units,
                        widthStarting + width + textFromLegend,
                        (3.64 * scaledHeightVel * (CGFloat(70) - CGFloat(index))) + heightFudge + startHeight
                    )
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "N0X":
            (0..<256).forEach { index in
                setColorWithBuffers(prodId: 159, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " dB"
            (-7...8).reversed().forEach { index in
                drawText(
                    String(index) + units,
                    widthStarting + width + textFromLegend,
                    (16 * scaledHeightVel * (CGFloat(8) - CGFloat(index))) + heightFudge + startHeight
                )
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
            }
        case "N0C":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 161, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " CC"
            (0...100).reversed().forEach { index in
                if index % 5 == 0 {
                    let tmpStr = String(Double(index)/100.0).truncate(4)
                    drawText(
                        tmpStr + units,
                        widthStarting + width + textFromLegend,
                        (CGFloat(3)*scaledHeightVel*CGFloat(100 - index)) + heightFudge + startHeight
                    )
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "N0K":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 163, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " PHAS"
            (-2...10).reversed().forEach { index in
                drawText(
                    String(index) + units,
                    widthStarting + width + textFromLegend,
                    (20.0 * scaledHeightVel * (10.0 - CGFloat(index))) + heightFudge + startHeight
                )
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
            }
        case "H0C":
            scaledHeight = (screenHeight - 2.0 * startHeight) / 160.0
            let labels = ["ND", "BI", "GC", "IC", "DS", "WS", "RA", "HR", "BD", "GR", "HA", "", "", "", "UK", "RF"]
            (0...159).forEach { index in
                setColorWithBuffers(prodId: 165, index: 160 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = ""
            (0...159).reversed().forEach { index in
                if index % 10 == 0 {
                    drawText(
                        labels[Int(index / 10)] + units,
                        widthStarting + width + textFromLegend,
                        (scaledHeight * (159.0 - CGFloat(index)))  + startHeight
                    )
                    if !unitsDrawn {
                        unitsDrawn = true
                        units = ""
                    }
                }
            }
        case "DSP":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 172, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " IN"
            var j = WXGLNexrad.wxoglDspLegendMax
            while j > 0 {
                let xVar = widthStarting + width + textFromLegend
                let yVar1 = CGFloat(255.0 / WXGLNexrad.wxoglDspLegendMax)
                    * scaledHeightVel
                    * CGFloat(WXGLNexrad.wxoglDspLegendMax - j)
                let yVar = yVar1 + heightFudge + startHeight
                drawText(String(j).truncate(4) + units, xVar, yVar)
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
                j -= WXGLNexrad.wxoglDspLegendMax / 16.0
            }
        case "DAA":
            (0...255).forEach { index in
                setColorWithBuffers(prodId: 172, index: 255 - index)
                drawRect(
                    widthStarting,
                    CGFloat(index) * scaledHeight + startHeight,
                    width + widthStarting,
                    CGFloat(index) * scaledHeight + scaledHeight + startHeight
                )
            }
            units = " IN"
            var j = WXGLNexrad.wxoglDspLegendMax
            while j > 0 {
                let xVar = widthStarting + width + textFromLegend
                let yVar1 = CGFloat(255.0 / WXGLNexrad.wxoglDspLegendMax)
                    * scaledHeightVel
                    * CGFloat(WXGLNexrad.wxoglDspLegendMax - j)
                let yVar = yVar1 + heightFudge + startHeight
                drawText(String(j).truncate(4) + units, xVar, yVar)
                if !unitsDrawn {
                    unitsDrawn = true
                    units = ""
                }
                j -= WXGLNexrad.wxoglDspLegendMax / 16.0
            }
        default:
            break
        }
    }
}
