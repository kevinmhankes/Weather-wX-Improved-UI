/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerLIGHTNING: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var timeButton = ObjectToolbarIcon()
    var sector = "usa_big"
    var sectorPretty = "USA"
    var period = "0.25"
    var periodPretty = "15 MIN"
    var firstRun = true

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        productButton = ObjectToolbarIcon(self, #selector(prodClicked))
        timeButton = ObjectToolbarIcon(self, #selector(timeClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(ViewControllerLIGHTNING.shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, timeButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        sector = Utility.readPref("LIGHTNING_SECTOR", sector)
        period = Utility.readPref("LIGHTNING_PERIOD", period)
        sectorPretty = UtilityLightning.getSectorPretty(sector)
        periodPretty = UtilityLightning.getTimePretty(period)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityLightning.getImage(self.sector, self.period)
            self.sectorPretty = UtilityLightning.getSectorPretty(self.sector)
            self.periodPretty = UtilityLightning.getTimePretty(self.period)
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(bitmap)
                }
                self.productButton.title = self.sectorPretty
                self.timeButton.title = self.periodPretty
                Utility.writePref("LIGHTNING_SECTOR", self.sector)
                Utility.writePref("LIGHTNING_PERIOD", self.period)
            }
        }
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    @objc func prodClicked() {
        _ = ObjectPopUp(self, "Region Selection", productButton, UtilityLightning.sectorList, self.sectorChanged(_:))
    }

    @objc func timeClicked() {
        _ = ObjectPopUp(self, "Time Selection", timeButton, UtilityLightning.timeList, self.timeChanged(_:))
    }

    func sectorChanged(_ idx: Int) {
        firstRun = true
        self.sectorPretty = UtilityLightning.sectorList[idx]
        self.sector = UtilityLightning.getSector(self.sectorPretty)
        self.getContent()
    }

    func timeChanged(_ index: Int) {
        self.periodPretty = UtilityLightning.timeList[index]
        self.period = UtilityLightning.getTime(self.periodPretty)
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
}
