/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsColorListing: UIwXViewController {

    // FIXME variable naming
    private var colorArr = [wXColor]()
    private var tvArr = [ObjectTextView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        setupColorObjects()
        colorArr.sort(by: {$0.uiLabel < $1.uiLabel})
        self.displayContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tvArr.enumerated().forEach {
            if $1.textcolor.colorsCurrent.red == 0
                && $1.textcolor.colorsCurrent.green == 0
                && $1.textcolor.colorsCurrent.blue == 0 {
                $1.color = UIColor.white
            } else {
                $1.color = $1.textcolor.uicolorCurrent
            }
        }
    }

    @objc override func doneClicked() {
        RadarGeometry.setColors()
        GeographyType.regen()
        PolygonType.regen()
        super.doneClicked()
    }

    func setupColorObjects() {
        colorArr.append(wXColor("Draw Tool", "DRAW_TOOL_COLOR", 255, 0, 0 ))
        colorArr.append(wXColor("Highways", "RADAR_COLOR_HW", 135, 135, 135 ))
        colorArr.append(wXColor("Secondary Roads", "RADAR_COLOR_HW_EXT", 91, 91, 91 ))
        colorArr.append(wXColor("State Lines", "RADAR_COLOR_STATE", 142, 142, 142 ))
        colorArr.append(wXColor("Thunderstorm warning", "RADAR_COLOR_TSTORM", 255, 255, 0 ))
        colorArr.append(wXColor("Thunderstorm watch", "RADAR_COLOR_TSTORM_WATCH", 255, 187, 0 ))
        colorArr.append(wXColor("Tornado warning", "RADAR_COLOR_TOR", 243, 85, 243 ))
        colorArr.append(wXColor("Tornado watch", "RADAR_COLOR_TOR_WATCH", 255, 0, 0 ))
        colorArr.append(wXColor("Flash flood warning", "RADAR_COLOR_FFW", 0, 255, 0 ))
        ObjectPolygonWarning.polygonList.forEach {
            let polygonType = ObjectPolygonWarning.polygonDataByType[$0]!
            colorArr.append(wXColor(polygonType.name, polygonType.prefTokenColor, polygonType.defaultColors[$0]!))
        }
        colorArr.append(wXColor("MCD", "RADAR_COLOR_MCD", 153, 51, 255 ))
        colorArr.append(wXColor("MPD", "RADAR_COLOR_MPD", 0, 255, 0 ))
        colorArr.append(wXColor("Location dot", "RADAR_COLOR_LOCDOT", 255, 255, 255 ))
        colorArr.append(wXColor("Spotters", "RADAR_COLOR_SPOTTER", 255, 0, 245 ))
        colorArr.append(wXColor("Cities", "RADAR_COLOR_CITY", 255, 255, 255 ))
        colorArr.append(wXColor("Lakes and rivers", "RADAR_COLOR_LAKES", 0, 0, 255 ))
        colorArr.append(wXColor("Counties", "RADAR_COLOR_COUNTY", 75, 75, 75 ))
        colorArr.append(wXColor("Storm tracks", "RADAR_COLOR_STI", 255, 255, 255 ))
        colorArr.append(wXColor("Hail indicators", "RADAR_COLOR_HI", 0, 255, 0 ))
        colorArr.append(wXColor("Observations", "RADAR_COLOR_OBS", 255, 255, 255 ))
        colorArr.append(wXColor("Wind Barbs", "RADAR_COLOR_OBS_WINDBARBS", 255, 255, 255 ))
        colorArr.append(wXColor("County labels", "RADAR_COLOR_COUNTY_LABELS", 234, 214, 123 ))
        colorArr.append(wXColor("NWS Forecast Icon Text color", "NWS_ICON_TEXT_COLOR", 38, 97, 139 ))
        colorArr.append(wXColor("NWS Forecast Icon Bottom color", "NWS_ICON_BOTTOM_COLOR", 255, 255, 255 ))
        colorArr.append(wXColor("Nexrad Radar Background color", "NEXRAD_RADAR_BACKGROUND_COLOR", 0, 0, 0 ))
    }

    @objc func gotoColor(sender: UITapGestureRecognizerWithData) {
        let vc = vcSettingsColorPicker()
        vc.colorObject = colorArr[sender.data]
        self.goToVC(vc)
    }

    private func displayContent() {
        colorArr.enumerated().forEach {
            let objText = ObjectTextView(self.stackView, $1.uiLabel, $1)
            if $1.colorsCurrent.red == 0 && $1.colorsCurrent.green == 0 && $1.colorsCurrent.blue == 0 {
                objText.color = UIColor.white
            } else {
                objText.color = $1.uicolorCurrent
            }
            objText.background = UIColor.black
            objText.tv.font = FontSize.extraLarge.size
            objText.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(gotoColor(sender:))))
            objText.tv.isSelectable = false
            tvArr.append(objText)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
