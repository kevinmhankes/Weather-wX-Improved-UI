/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectToolbarIcon: UIBarButtonItem {
    
    static let oldIconToNew: [String: String] = [
        "ic_arrow_back_white_24dp": "chevron.left",
        "ic_play_arrow_24dp": "play.fill",
        "ic_share_24dp": "square.and.arrow.up",
        "ic_queue_24dp": "folder.badge.plus",
        "ic_gps_fixed_white_24dp": "location.fill",
        "ic_delete_24dp": "trash.fill",
        "ic_search_24dp": "magnifyingglass",
        "ic_done_24dp": "checkmark",
        "ic_report_24dp": "exclamationmark.shield.fill",
        "ic_cloud_24dp": "smoke.fill",
        "ic_info_outline_24dp": "doc.circle.fill",
        "ic_more_vert_white_24dp": "ellipsis",
        "ic_add_box_24dp": "plus.app.fill",
        "ic_flash_on_24dp": "bolt.fill",
        "ic_keyboard_arrow_left_24dp": "chevron.left",
        "ic_keyboard_arrow_right_24dp": "chevron.right",
        "ic_get_app_24dp": "arrow.2.circlepath.circle.fill",
        "ic_stop_24dp": "stop.fill",
        "ic_pause_24dp": "pause.fill"
    ]
    
    static let iconToString: [IconType: String] = [
        .share: "ic_share_24dp",
        .pause: "ic_pause_24dp",
        .play: "ic_play_arrow_24dp",
        .playList: "ic_queue_24dp",
        .stop: "ic_stop_24dp",
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
        .rightArrow: "ic_keyboard_arrow_right_24dp",
        .download: "ic_get_app_24dp"
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
    
    static func getIcon(_ iconStr: String) -> UIImage {
        if #available(iOS 13, *) {
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            let color = UIColor.white
            let newIconValue = ObjectToolbarIcon.oldIconToNew[iconStr]
            if newIconValue != nil {
                return (UIImage(
                    systemName: newIconValue!,
                    withConfiguration: configuration
                    )?.withTintColor(color, renderingMode: .alwaysOriginal))!
            }
        }
        return UIImage(named: iconStr)!
    }
    
    let toolbarIconPadding: CGFloat = 11
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
            top: toolbarIconPadding,
            left: toolbarIconPadding,
            bottom: toolbarIconPadding,
            right: toolbarIconPadding
        )
        button.setImage(UIImage(named: iconStr), for: .normal)
        if #available(iOS 13, *) {
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            let color = UIColor.white
            let newIconValue = ObjectToolbarIcon.oldIconToNew[iconStr]
            if newIconValue != nil {
                let image = UIImage(
                    systemName: newIconValue!,
                    withConfiguration: configuration
                    )?.withTintColor(color, renderingMode: .alwaysOriginal)
                button.setImage(image, for: .normal)
            }
        }
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
    
    func setImage(_ iconType: IconType) {
        let fileName = ObjectToolbarIcon.iconToString[iconType] ?? ""
        button.setImage(UIImage(named: fileName), for: .normal)
        if #available(iOS 13, *) {
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            let color = UIColor.white
            let newIconValue = ObjectToolbarIcon.oldIconToNew[fileName]
            if newIconValue != nil {
                let image = UIImage(
                    systemName: newIconValue!,
                    withConfiguration: configuration
                    )?.withTintColor(color, renderingMode: .alwaysOriginal)
                button.setImage(image, for: .normal)
            }
        }
    }
}
