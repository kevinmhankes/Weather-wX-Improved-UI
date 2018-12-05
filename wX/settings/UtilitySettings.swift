/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySettings {

    static func getHelp(_ sender: UIButton, _ uiv: UIViewController,
                        _ targetButton: UIBarButtonItem,
                        _ helpMap: [String: String]) {
        let alert = ObjectPopUp(uiv, helpMap[(sender.titleLabel?.text)!]!, targetButton)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.finish()
    }
    
    static func getHelp(_ uiv: UIViewController,
                        _ targetButton: UIBarButtonItem,
                        _ help: String) {
        let alert = ObjectPopUp(uiv, help, targetButton)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.finish()
    }

    static func switchChanged(sender: ObjectSettingsSwitch) {
        let prefLabels = [String](sender.prefMap.keys).sorted(by: <)
        let isOnQ = sender.sw.isOn
        var truthString = "false"
        if isOnQ {truthString = "true"}
        editor.putString(prefLabels[sender.sw.tag], truthString)
    }
}
