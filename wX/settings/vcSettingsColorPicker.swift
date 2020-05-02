/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsColorPicker: UIwXViewController, HSBColorPickerDelegate {
    
    private var colorBarSize: CGFloat = 100.0
    private var colorBar = UIView()
    private var newRed =  0
    private var newGreen = 0
    private var newBlue = 0
    private var colorChanged = false
    private var colorButton = ObjectToolbarIcon()
    private let toolbarTop = ObjectToolbar()
    private var colPicker: HSBColorPicker!
    var colorObject = wXColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelButton = ObjectToolbarIcon(title: colorObject.uiLabel, self, nil)
        toolbarTop.items = ObjectToolbarItems([GlobalVariables.flexBarButton, labelButton]).items
        let defaultButton = ObjectToolbarIcon(title: "Set to default", self, #selector(saveDefaultColorClicked))
        colorButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, colorButton, defaultButton]).items
        colPicker = HSBColorPicker()
        colPicker.delegate = self
        refreshViews()
        colorBar.backgroundColor = colorObject.uicolorCurrent
        colorButton.title = "(" + String(colorObject.colorsCurrent.red)
            + ", "
            + String(colorObject.colorsCurrent.green)
            + ", "
            + String(colorObject.colorsCurrent.blue)
            + ")"
        self.view.addSubview(colPicker)
        self.view.addSubview(colorBar)
        // FIXME sizing is not working , should not need to add toolbar
        self.view.addSubview(toolbar)
        self.view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
    }
    
    @objc override func doneClicked() {
        if colorChanged { saveNewColorClicked() }
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
        colorButton.title = "(" + String(newRed) + ", " + String(newGreen) + ", " + String(newBlue) + ")"
    }
    
    func saveNewColorClicked() {
        Utility.writePref(colorObject.prefVar, Color.rgb(newRed, newGreen, newBlue))
        colorBar.backgroundColor = wXColor.uiColorInt(newRed, newGreen, newBlue)
        colorObject.regenCurrentColor()
    }
    
    @objc func saveDefaultColorClicked() {
        Utility.writePref(colorObject.prefVar, Color.rgb(colorObject.defaultRed, colorObject.defaultGreen, colorObject.defaultBlue))
        colorBar.backgroundColor = colorObject.uicolorDefault
        colorObject.regenCurrentColor()
        newRed = colorObject.defaultRed
        newGreen = colorObject.defaultGreen
        newBlue = colorObject.defaultBlue
        colorChanged = true
        colorButton.title = "(" + String(newRed) + ", " + String(newGreen) + ", " + String(newBlue) + ")"
    }
    
    internal override func refreshViews() {
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        colPicker.frame = CGRect(
            x: 0,
            y: toolbar.height + UtilityUI.getTopPadding(),
            width: width,
            height: height
                - toolbar.height * 2
                - colorBarSize
                - UtilityUI.getTopPadding()
        )
        colorBar.frame = CGRect(
            x: 0,
            y: height - toolbar.height - colorBarSize,
            width: width,
            height: colorBarSize
        )
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.refreshViews() })
    }
}
