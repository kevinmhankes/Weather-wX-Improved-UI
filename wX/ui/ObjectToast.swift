/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectToast {

    init(_ msg: String, _ uiv: UIViewController, _ menuButton: UIBarButtonItem) {
        let alert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        uiv.present(alert, animated: true, completion: nil)
    }
}
