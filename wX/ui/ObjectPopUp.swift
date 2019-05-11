/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectPopUp {

    private var alert = UIAlertController()
    private var uiv: UIViewController
    private var button: UIBarButtonItem

    init(_ uiv: UIViewController, _ title: String, _ button: UIBarButtonItem) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        self.button = button
        self.uiv = uiv
    }

    init(_ uiv: UIViewController,
         _ title: String,
         _ button: UIBarButtonItem,
         _ list: [String],
         _ fn: @escaping (String) -> Void
    ) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
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
         _ list: [Int],
         _ fn: @escaping (Int) -> Void
    ) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        self.button = button
        self.uiv = uiv
        list.forEach { item in
            addAction(UIAlertAction(String(item), {_ in fn(item)}))
        }
        finish()
    }

    init(_ uiv: UIViewController,
         _ title: String,
         _ button: UIBarButtonItem,
         _ list: StrideTo<Int>,
         _ fn: @escaping (Int) -> Void
    ) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        self.button = button
        self.uiv = uiv
        list.forEach { item in
            addAction(UIAlertAction(String(item), {_ in fn(item)}))
        }
        finish()
    }

    init(_ uiv: UIViewController,
         _ title: String,
         _ button: UIBarButtonItem,
         _ list: [String],
         _ fn: @escaping (Int) -> Void
    ) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        self.button = button
        self.uiv = uiv
        list.forEach {
            let index = list.firstIndex(of: $0)!
            addAction(UIAlertAction($0, {_ in fn(index)}))
        }
        finish()
    }

    init(_ uiv: UIViewController,
         _ title: String,
         _ button: UIBarButtonItem,
         _ list: [ObjectMenuTitle],
         _ fn: @escaping (Int) -> Void
    ) {
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        self.button = button
        self.uiv = uiv
        list.enumerated().forEach { index, title in
            addAction(UIAlertAction(title.title, {_ in fn(index)}))
        }
        finish()
    }

    init(_ uiv: UIViewController,
         _ button: UIBarButtonItem,
         _ list: [ObjectMenuTitle],
         _ index: Int,
         _ menuData: ObjectMenuData,
         _ fn: @escaping (Int) -> Void
    ) {
        let startIdx = ObjectMenuTitle.getStart(list, index)
        let count = list[index].count
        let title = list[index].title
        alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        self.button = button
        self.uiv = uiv
        (startIdx..<(startIdx + count)).forEach { idx in
            let paramTitle = menuData.paramLabels[idx]
            alert.addAction(UIAlertAction(paramTitle, { _ in fn(idx)}))
        }
        finish()
    }

    func addAction(_ action: UIAlertAction) {
        alert.addAction(action)
    }

    func finish() {
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        uiv.present(alert, animated: true, completion: nil)
    }
}
