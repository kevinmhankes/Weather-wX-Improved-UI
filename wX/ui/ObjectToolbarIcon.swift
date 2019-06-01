/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectToolbarIcon: UIBarButtonItem {

    static let iconToString: [IconType: String] = [
        .share: "ic_share_24dp",
        .play: "ic_play_arrow_24dp",
        .playList: "ic_queue_24dp",
        .done: "ic_arrow_back_white_24dp",
        .radar: "ic_flash_on_24dp",
        .plus: "ic_add_box_24dp",
        .cloud: "ic_cloud_24dp",
        .save: "ic_done_24dp",
        .search: "ic_search_24dp",
        .delete: "ic_delete_24dp",
        .gps: "ic_gps_fixed_white_24dp",
        .submenu: "ic_more_vert_white_24dp",
        .wfo: "ic_info_outline_24dp",
        .severeDashboard: "ic_report_24dp",
        .leftArrow: "ic_keyboard_arrow_left_24dp",
        .rightArrow: "ic_keyboard_arrow_right_24dp"
    ]
    
    static let iconToAccessibilityLabel: [IconType: String] = [
        .share: "share content",
        .play: "play",
        .playList: "play list",
        .done: "go back",
        .radar: "radar",
        .plus: "add",
        .cloud: "cloud",
        .save: "save",
        .search: "search",
        .delete: "delete",
        .gps: "GPS",
        .submenu: "submenu",
        .wfo: "wfo",
        .severeDashboard: "severe dashboard",
        .leftArrow: "go left",
        .rightArrow: "go right"
    ]

    var button = UIButton()

    override init() {
        super.init()
    }

    convenience init(_ uiv: UIViewController, _ iconStr: String, _ action: Selector) {
        self.init()
        button = UIButton(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIPreferences.toolbarHeight,
                height: UIPreferences.toolbarHeight
            )
        )
        button.imageEdgeInsets = UIEdgeInsets(
            top: UIPreferences.toolbarIconPadding,
            left: UIPreferences.toolbarIconPadding,
            bottom: UIPreferences.toolbarIconPadding,
            right: UIPreferences.toolbarIconPadding
        )
        button.setImage(UIImage(named: iconStr), for: .normal)
        customView = button
        button.addTarget(uiv, action: action, for: .touchUpInside)
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }

    convenience init(_ uiv: UIViewController, _ iconType: IconType, _ action: Selector) {
        self.init(uiv, ObjectToolbarIcon.iconToString[iconType] ?? "", action)
        button.isAccessibilityElement = true
        button.accessibilityLabel = ObjectToolbarIcon.iconToAccessibilityLabel[iconType] ?? "No label"
    }

    convenience init(_ target: UIViewController, _ action: Selector?) {
        self.init(title: "", style: UIBarButtonItem.Style.plain, target: target, action: action)
    }

    convenience init(title: String, _ target: UIViewController, _ action: Selector?) {
        self.init(title: title, style: UIBarButtonItem.Style.plain, target: target, action: action)
    }

    convenience init(title: String, _ target: UIViewController, _ action: Selector?, tag: Int) {
        self.init(title: title, style: UIBarButtonItem.Style.plain, target: target, action: action)
        self.tag = tag
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    func setImage(_ image: UIImage, for: UIControl.State) {
        button.setImage(image, for: .normal)
    }
}
