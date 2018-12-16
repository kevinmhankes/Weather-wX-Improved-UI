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

    init(_ uiv: UIViewController,
         _ title: String,
         _ button: UIBarButtonItem,
         _ list: [String],
         _ fn: @escaping (String) -> Void) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.button = button
        self.uiv = uiv
        list.forEach { item in
            var code = item
            if item.contains(":") {
                code = item.firstToken(":")
            }
            addAction(UIAlertAction(item, {_ in fn(code)}))
        }
        finish()
    }

    init(_ uiv: UIViewController,
         _ title: String,
         _ button: UIBarButtonItem,
         _ list: [String],
         _ fn: @escaping (Int) -> Void) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.button = button
        self.uiv = uiv
        list.forEach {
            let index = list.index(of: $0)!
            addAction(UIAlertAction($0, {_ in fn(index)}))
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
