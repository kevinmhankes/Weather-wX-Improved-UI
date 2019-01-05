/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
        let labelButton = ObjectToolbarIcon(title: ActVars.colorObject.uiLabel, self, nil)
        toolbarTop.items = ObjectToolbarItems([flexBarButton, labelButton]).items
        let defaultButton = ObjectToolbarIcon(title: "Set to default", self, #selector(saveDefaultColorClicked))
        colorButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, colorButton, defaultButton]).items
        let colPicker = HSBColorPicker(
            frame: CGRect(
                x: 0,
                y: toolbar.frame.size.height + UIPreferences.statusBarHeight,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
                    - toolbar.frame.size.height * 2
                    - colorBarSize
                    - UIPreferences.statusBarHeight
            )
        )
        colPicker.delegate = self
        self.view.addSubview(colPicker)
        colorBar = UIView(
            frame: CGRect(
                x: 0,
                y: UIScreen.main.bounds.height - toolbar.frame.size.height - colorBarSize,
                width: UIScreen.main.bounds.width,
                height: colorBarSize
            )
        )
        colorBar.backgroundColor = ActVars.colorObject.uicolorCurrent
        colorButton.title = "(" + String(ActVars.colorObject.colorsCurrent.0)
            + ","
            + String(ActVars.colorObject.colorsCurrent.1)
            + ","
            + String(ActVars.colorObject.colorsCurrent.2)
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

    func HSBColorColorPickerTouched(
        sender: HSBColorPicker,
        color: UIColor,
        point: CGPoint,
        state: UIGestureRecognizer.State
    ) {
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
        editor.putInt(ActVars.colorObject.prefVar, Color.rgb(newRed, newGreen, newBlue))
        colorBar.backgroundColor = wXColor.uiColorInt(newRed, newGreen, newBlue)
        ActVars.colorObject.regenCurrentColor()
    }

    @objc func saveDefaultColorClicked() {
        editor.putInt(
            ActVars.colorObject.prefVar,
            Color.rgb(
                ActVars.colorObject.defaultRed,
                ActVars.colorObject.defaultGreen,
                ActVars.colorObject.defaultBlue
            )
        )
        colorBar.backgroundColor = ActVars.colorObject.uicolorDefault
        ActVars.colorObject.regenCurrentColor()
        newRed = ActVars.colorObject.defaultRed
        newGreen = ActVars.colorObject.defaultGreen
        newBlue = ActVars.colorObject.defaultBlue
        colorChanged = true
        colorButton.title = "(" + String(newRed) + "," + String(newGreen) + "," + String(newBlue) + ")"
    }
}
