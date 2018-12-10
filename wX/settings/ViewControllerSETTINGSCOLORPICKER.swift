/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSCOLORPICKER: UIwXViewController, HSBColorPickerDelegate {

    var colorBarSize: CGFloat = 100.0
    var colorBar = UIView()
    var newRed =  0
    var newGreen = 0
    var newBlue = 0
    var colorChanged = false
    var colorButton = ObjectToolbarIcon()
    let toolbarTop = ObjectToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTop.setConfig(.top)
        let labelButton = ObjectToolbarIcon(title: ActVars.ColorObject.uiLabel, self, nil)
        toolbarTop.items = ObjectToolbarItems([flexBarButton, labelButton]).items
        let defaultButton = ObjectToolbarIcon(title: "Set to default", self, #selector(saveDefaultColorClicked))
        colorButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, colorButton, defaultButton]).items
        let colPicker = HSBColorPicker(frame: CGRect(x: 0,
                                                     y: toolbar.frame.size.height + UIPreferences.statusBarHeight,
                                                     width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height - toolbar.frame.size.height * 2 - colorBarSize - UIPreferences.statusBarHeight))
        colPicker.delegate = self
        self.view.addSubview(colPicker)
        colorBar = UIView(frame: CGRect(x: 0,
                                        y: UIScreen.main.bounds.height - toolbar.frame.size.height - colorBarSize,
                                        width: UIScreen.main.bounds.width,
                                        height: colorBarSize ))
        colorBar.backgroundColor = ActVars.ColorObject.uicolorCurrent
        colorButton.title = "(" + String(ActVars.ColorObject.colorsCurrent.0)
            + ","
            + String(ActVars.ColorObject.colorsCurrent.1)
            + ","
            + String(ActVars.ColorObject.colorsCurrent.2)
            + ")"
        self.view.addSubview(colorBar)
        self.view.addSubview(toolbar)
        self.view.addSubview(toolbarTop)
    }

    @objc override func doneClicked() {
        if colorChanged {
            saveNewColorClicked()
        }
        super.doneClicked()
    }

    func HSBColorColorPickerTouched(sender: HSBColorPicker,
                                    color: UIColor,
                                    point: CGPoint,
                                    state: UIGestureRecognizerState) {
        let myColorComponents = color.components
        let colorInt: Int = (0xFF << 24)
            | (myColorComponents.red << 16)
            | (myColorComponents.green << 8)
            | myColorComponents.blue
        newRed = (colorInt >> 16) & 0xFF
        newGreen = (colorInt >> 8) & 0xFF
        newBlue = colorInt & 0xFF
        colorBar.backgroundColor = wXColor.uiColorInt(newRed, newGreen, newBlue)
        colorChanged = true
        colorButton.title = "(" + String(newRed) + "," + String(newGreen) + "," + String(newBlue) + ")"
    }

    func saveNewColorClicked() {
        editor.putInt(ActVars.ColorObject.prefVar, Color.rgb(newRed, newGreen, newBlue))
        colorBar.backgroundColor = wXColor.uiColorInt(newRed, newGreen, newBlue)
        ActVars.ColorObject.regenCurrentColor()
    }

    @objc func saveDefaultColorClicked() {
        editor.putInt(ActVars.ColorObject.prefVar,
                      Color.rgb(ActVars.ColorObject.defaultRed,
                                ActVars.ColorObject.defaultGreen,
                                ActVars.ColorObject.defaultBlue))
        colorBar.backgroundColor = ActVars.ColorObject.uicolorDefault
        ActVars.ColorObject.regenCurrentColor()
        newRed = ActVars.ColorObject.defaultRed
        newGreen = ActVars.ColorObject.defaultGreen
        newBlue = ActVars.ColorObject.defaultBlue
        colorChanged = true
        colorButton.title = "(" + String(newRed) + "," + String(newGreen) + "," + String(newBlue) + ")"
    }
}
