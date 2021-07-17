/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcWpcImg: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var index = 0
    private var timePeriod = 1
    private let subMenu = MenuData(UtilityWpcImages.titles, UtilityWpcImages.urls, UtilityWpcImages.labels)
    var wpcImagesFromHomeScreen = false
    var wpcImagesToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(showProductMenu))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = TouchImage(self, toolbar, #selector(handleSwipes))
        index = Utility.readPref("WPCIMG_PARAM_LAST_USED", index)
        if wpcImagesFromHomeScreen {
            getContentFromHomeScreen()
            wpcImagesFromHomeScreen = false
        } else {
            getContent(index)
        }
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        productButton.title = UtilityWpcImages.labels[index]
        var getUrl = UtilityWpcImages.urls[self.index]
        if getUrl.contains(GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/") {
            getUrl += String(timePeriod) + "_conus.png"
        }
        Utility.writePref("WPCIMG_PARAM_LAST_USED", index)
        _ = FutureBytes(getUrl, image.setBitmap)
    }

    func getContentFromHomeScreen() {
        let titles = GlobalArrays.nwsImageProducts.filter { $0.hasPrefix(wpcImagesToken + ":") }
        if titles.count > 0 {
            productButton.title = titles[0].split(":")[1]
        }
        _ = FutureBytes2({ UtilityDownload.getImageProduct(self.wpcImagesToken) }, image.setBitmap)
    }

    @objc func showProductMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, showSubMenu)
    }

    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, productButton, subMenu.objTitles, index, subMenu, getContent)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityWpcImages.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.image.refresh() })
    }
}
