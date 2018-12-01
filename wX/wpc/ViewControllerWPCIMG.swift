/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerWPCIMG: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var index = 0
    var timePeriod = 1
    var subMenu = ObjectMenuData(UtilityWPCImages.TITLES, UtilityWPCImages.urls, UtilityWPCImages.LABELS)

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(showProdMenu))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        index = preferences.getInt("WPCIMG_PARAM_LAST_USED", index)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var getUrl = UtilityWPCImages.urls[self.index]
            if getUrl.contains("http://graphical.weather.gov/images/conus/") {
                getUrl += String(self.timePeriod) + "_conus.png"
            }
            let bitmap = Bitmap(getUrl)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityWPCImages.LABELS[self.index]
                editor.putInt("WPCIMG_PARAM_LAST_USED", self.index)
            }
        }
    }
    @objc func showProdMenu() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        subMenu.objTitles.enumerated().forEach { index, title in
            alert.addAction(UIAlertAction(title: title.title, style: .default, handler: {_ in self.showSubMenu(index)}))
        }
        alert.finish()
    }

    func showSubMenu(_ index: Int) {
        let startIdx  = ObjectMenuTitle.getStart(subMenu.objTitles, index)
        let count = subMenu.objTitles[index].count
        let title = subMenu.objTitles[index].title
        let alert = ObjectPopUp(self, title, productButton)
        (startIdx..<(startIdx + count)).forEach { index in
            let paramTitle = subMenu.paramLabels[index]
            alert.addAction(UIAlertAction(title: paramTitle, style: .default, handler: {_ in
                self.productChanged(index)}))
        }
        alert.finish()
    }

    func productChanged(_ product: Int) {
        self.index = product
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, image.bitmap)}

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityWPCImages.urls)
        getContent()
    }
}
