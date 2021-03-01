/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectFab {
    
    private let floaty = Floaty(frame: UIScreen.main.bounds, size: 56)
    
    init(_ uiv: UIViewController, _ action: Selector, iconType: IconType = .radar) {
        floaty.sticky = true
        floaty.friendlyTap = false
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
        setColor()
        setImage(iconType)
        floaty.addGestureRecognizer(UITapGestureRecognizer(target: uiv, action: action))
        uiv.view.addSubview(view)
    }
    
    func setImage(_ iconType: IconType) {
        #if targetEnvironment(macCatalyst)

        #else
        let imageString = ObjectToolbarIcon.iconToString[iconType] ?? ""
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: imageString)!, 0.50)
        if #available(iOS 13, *) {
            // print(imageString)
            let configuration = UIImage.SymbolConfiguration(weight: .medium)
            let color = UIColor.white
            let newIconValue = ObjectToolbarIcon.oldIconToNew[imageString]
            if newIconValue != nil {
                let image = UIImage(
                    systemName: newIconValue!,
                    withConfiguration: configuration
                    )?.withTintColor(color, renderingMode: .alwaysOriginal)
                floaty.buttonImage = UtilityImg.resizeImage(image!, 1.00)
            }
        }
        #endif
    }
    
    func setColor() {
        floaty.buttonColor = AppColors.primaryColorFab
    }
    
    func resize() {
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
    }
    
    func setToTheLeft() {
        floaty.paddingX = 76.0
    }
    
    func close() {
        floaty.close()
    }
    
    var view: Floaty { floaty }
}
