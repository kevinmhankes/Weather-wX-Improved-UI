/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsColorListing: UIwXViewController {
    
    private var colors = [wXColor]()
    private var objectTextViews = [ObjectTextView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        stackView.spacing = 0
        setupColorObjects()
        colors.sort(by: {$0.uiLabel < $1.uiLabel})
        display()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        objectTextViews.forEach { tv in
            if tv.textColor.colorsCurrent.red == 0
                && tv.textColor.colorsCurrent.green == 0
                && tv.textColor.colorsCurrent.blue == 0 {
                tv.color = UIColor.white
            } else {
                tv.color = tv.textColor.uiColorCurrent
            }
        }
    }
    
    override func doneClicked() {
        RadarGeometry.setColors()
        GeographyType.regen()
        PolygonType.regen()
        super.doneClicked()
    }
    
    func setupColorObjects() {
        colors.append(wXColor("Highways", "RADAR_COLOR_HW", 135, 135, 135 ))
        colors.append(wXColor("Secondary Roads", "RADAR_COLOR_HW_EXT", 91, 91, 91 ))
        colors.append(wXColor("State Lines", "RADAR_COLOR_STATE", 142, 142, 142 ))
        colors.append(wXColor("Thunderstorm Warning", "RADAR_COLOR_TSTORM", 255, 255, 0 ))
        colors.append(wXColor("Thunderstorm Watch", "RADAR_COLOR_TSTORM_WATCH", 255, 187, 0 ))
        colors.append(wXColor("Tornado Warning", "RADAR_COLOR_TOR", 243, 85, 243 ))
        colors.append(wXColor("Tornado Watch", "RADAR_COLOR_TOR_WATCH", 255, 0, 0 ))
        colors.append(wXColor("Flash Flood Warning", "RADAR_COLOR_FFW", 0, 255, 0 ))
        ObjectPolygonWarning.polygonList.forEach { poly in
            let polygonType = ObjectPolygonWarning.polygonDataByType[poly]!
            colors.append(wXColor(polygonType.name, polygonType.prefTokenColor, polygonType.defaultColors[poly]!))
        }
        colors.append(wXColor("MCD", "RADAR_COLOR_MCD", 153, 51, 255 ))
        colors.append(wXColor("MPD", "RADAR_COLOR_MPD", 0, 255, 0 ))
        colors.append(wXColor("Location Dot", "RADAR_COLOR_LOCDOT", 255, 255, 255 ))
        colors.append(wXColor("Spotters", "RADAR_COLOR_SPOTTER", 255, 0, 245 ))
        colors.append(wXColor("Cities", "RADAR_COLOR_CITY", 255, 255, 255 ))
        colors.append(wXColor("Lakes and Rivers", "RADAR_COLOR_LAKES", 0, 0, 255 ))
        colors.append(wXColor("Counties", "RADAR_COLOR_COUNTY", 75, 75, 75 ))
        colors.append(wXColor("Storm Tracks", "RADAR_COLOR_STI", 255, 255, 255 ))
        colors.append(wXColor("Hail Indicators", "RADAR_COLOR_HI", 0, 255, 0 ))
        colors.append(wXColor("Observations", "RADAR_COLOR_OBS", 255, 255, 255 ))
        colors.append(wXColor("Wind Barbs", "RADAR_COLOR_OBS_WINDBARBS", 255, 255, 255 ))
        colors.append(wXColor("County Labels", "RADAR_COLOR_COUNTY_LABELS", 234, 214, 123 ))
        colors.append(wXColor("NWS Forecast Icon Text Color", "NWS_ICON_TEXT_COLOR", 38, 97, 139 ))
        colors.append(wXColor("NWS Forecast Icon Bottom Color", "NWS_ICON_BOTTOM_COLOR", 255, 255, 255 ))
        colors.append(wXColor("Nexrad Radar Background Color", "NEXRAD_RADAR_BACKGROUND_COLOR", 0, 0, 0 ))
    }
    
    @objc func goToColor(sender: UITapGestureRecognizerWithData) {
        Route.colorPicker(self, colors[sender.data])
    }
    
    private func display() {
        colors.enumerated().forEach { index, color in
            let objectTextView = ObjectTextView(stackView, color.uiLabel, color)
            if color.colorsCurrent.red == 0 && color.colorsCurrent.green == 0 && color.colorsCurrent.blue == 0 {
                objectTextView.color = UIColor.white
            } else {
                objectTextView.color = color.uiColorCurrent
            }
            objectTextView.background = UIColor.black
            objectTextView.tv.font = FontSize.extraLarge.size
            objectTextView.addGestureRecognizer(UITapGestureRecognizerWithData(index, self, #selector(goToColor(sender:))))
            objectTextView.tv.isSelectable = false
            objectTextView.constrain(scrollView)
            objectTextViews.append(objectTextView)
        }
    }
}
