/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSlider {

    let button = UIButton(type: UIButton.ButtonType.system)
    let slider: UISlider
    static let step: Float = 1 // If you want UISlider to snap to steps by 10
    let prefVar: String
    let label: String
    let initialValue: Int

    init(
        _ uiv: UIViewController,
        _ stackView: UIStackView,
        _ prefVar: String
    ) {
        self.label = ObjectSlider.prefToLabel[prefVar]!
        initialValue = Utility.readPref(prefVar, ObjectSlider.prefToInitialValue[prefVar]!)
        print(initialValue)
        print(prefVar)
        self.prefVar = prefVar
        slider = UISlider()
        slider.minimumValue = ObjectSlider.prefToMin[prefVar]!
        slider.maximumValue = ObjectSlider.prefToMax[prefVar]!
        slider.isContinuous = true
        slider.thumbTintColor = AppColors.primaryColorFab
        button.backgroundColor = UIColor.white
        let container = ObjectCardStackView(arrangedSubviews: [button, slider])
        stackView.addArrangedSubview(container.view)
        slider.value = Float(initialValue)
        setLabel()
    }

    func setLabel() {
        button.setTitle(label + "(" + String(ObjectSlider.prefToInitialValue[prefVar]!) + "): " + String(Int(slider.value)) + " ", for: .normal)
    }

    static let prefToLabel = [
        "RADAR_LOCDOT_SIZE": "Location dot size" ,
        "RADAR_SPOTTER_SIZE": "Spotter size",
        "RADAR_COLOR_PALETTE_94": "Reflectivity Colormap",
        "RADAR_COLOR_PALETTE_99": "Velocity Colormap",
        "RADAR_HI_SIZE": "Hail marker size",
        "RADAR_TVS_SIZE": "TVS marker size",
        "RADAR_AVIATION_SIZE": "Aviation dot size",
        "RADAR_OBS_EXT_ZOOM": "Detailed Observations Zoom",
        "RADAR_DATA_REFRESH_INTERVAL": "Radar data refresh interval",
        "WXOGL_SIZE": "Radar initial view size",

        "TEXTVIEW_FONT_SIZE": "Defaut font size" ,
        "UI_THEME": "Color theme" ,
        "REFRESH_LOC_MIN": "Refresh interval main screen(min)" ,
        "ANIM_INTERVAL": "Animation frame rate" ,
        "UI_TILES_PER_ROW": "Tiles per row",
        "HOMESCREEN_TEXT_LENGTH_PREF": "Homescreen text length",
        "NWS_ICON_SIZE_PREF": "NWS Icon size"
    ]

    // FIXME use these in MyApp for default value in readPref
    static let prefToInitialValue: [String: Int] = [
        "RADAR_LOCDOT_SIZE": 4,
        "RADAR_SPOTTER_SIZE": 5,
        "RADAR_HI_SIZE": 4,
        "RADAR_TVS_SIZE": 4,
        "RADAR_AVIATION_SIZE": 4,
        "RADAR_OBS_EXT_ZOOM": 7,
        "RADAR_DATA_REFRESH_INTERVAL": 5,
        "WXOGL_SIZE": 10,

        "TEXTVIEW_FONT_SIZE": 16,
        "REFRESH_LOC_MIN": 10,
        "ANIM_INTERVAL": 6,
        "UI_TILES_PER_ROW": 3,
        "HOMESCREEN_TEXT_LENGTH_PREF": 500,
        "NWS_ICON_SIZE_PREF": 80
    ]
    
    static let prefToMin: [String: Float] = [
            "RADAR_LOCDOT_SIZE": 0.0,
            "RADAR_SPOTTER_SIZE": 0.0,
            "RADAR_HI_SIZE": 0.0,
            "RADAR_TVS_SIZE": 0.0,
            "RADAR_AVIATION_SIZE": 0.0,
            "RADAR_OBS_EXT_ZOOM": 0.0,

            "TEXTVIEW_FONT_SIZE": 0.0,
            "REFRESH_LOC_MIN": 0.0,
            "ANIM_INTERVAL": 0.0,
            "HOMESCREEN_TEXT_LENGTH_PREF": 250.0,
            "NWS_ICON_SIZE_PREF": 0.0,
    ]

    static let prefToMax: [String: Float] = [
            "RADAR_LOCDOT_SIZE": 10.0,
            "RADAR_SPOTTER_SIZE": 10.0,
            "RADAR_HI_SIZE": 14.0,
            "RADAR_TVS_SIZE": 14.0,
            "RADAR_AVIATION_SIZE": 10.0,
            "RADAR_OBS_EXT_ZOOM": 10.0,

            "TEXTVIEW_FONT_SIZE": 20.0,
            "REFRESH_LOC_MIN": 120.0,
            "ANIM_INTERVAL": 16.0,
            "HOMESCREEN_TEXT_LENGTH_PREF": 2000.0,
            "NWS_ICON_SIZE_PREF": 100.0
    ]
}
