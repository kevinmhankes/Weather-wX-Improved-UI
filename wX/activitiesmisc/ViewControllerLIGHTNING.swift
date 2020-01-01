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
    var bitmap = Bitmap()

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
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, timeButton, shareButton]).items
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
            self.bitmap = UtilityLightning.getImage(self.sector, self.period)
            self.sectorPretty = UtilityLightning.getSectorPretty(self.sector)
            self.periodPretty = UtilityLightning.getTimePretty(self.period)
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(self.bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(self.bitmap)
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
        _ = ObjectPopUp(self, "Region Selection", productButton, UtilityLightning.sectors, self.sectorChanged(_:))
    }

    @objc func timeClicked() {
        _ = ObjectPopUp(self, "Time Selection", timeButton, UtilityLightning.times, self.timeChanged(_:))
    }

    func sectorChanged(_ idx: Int) {
        firstRun = true
        self.sectorPretty = UtilityLightning.sectors[idx]
        self.sector = UtilityLightning.getSector(self.sectorPretty)
        self.getContent()
    }

    func timeChanged(_ index: Int) {
        self.periodPretty = UtilityLightning.times[index]
        self.period = UtilityLightning.getTime(self.periodPretty)
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    private func displayContent() {
        image = ObjectTouchImageView(self, toolbar)
        self.image.setBitmap(self.bitmap)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.removeAllViews()
                self.view.addSubview(self.toolbar)
                self.displayContent()
            }
        )
    }
}
