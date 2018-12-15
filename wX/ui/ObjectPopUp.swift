/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectPopUp {

    private var alert = UIAlertController()
    private var uiv: UIViewController
    private var button: UIBarButtonItem

    init(_ uiv: UIViewController, _ title: String, _ button: UIBarButtonItem) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.button = button
        self.uiv = uiv
    }
    
    init(_ uiv: UIViewController, _ title: String, _ button: UIBarButtonItem,_ list: [String],_ fn: @escaping (String) -> ()) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.button = button
        self.uiv = uiv
        list.forEach { item in
            addAction(UIAlertAction(item, {_ in fn(item)}))
        }
        finish()
    }

    func addAction(_ action: UIAlertAction) {
        alert.addAction(action)
    }

    func finish() {
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        uiv.present(alert, animated: true, completion: nil)
    }
}
