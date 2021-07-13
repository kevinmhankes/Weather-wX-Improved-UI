/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcLightning: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var timeButton = ToolbarIcon()
    private var sector = "usa_big"
    private var sectorPretty = "USA"
    private var period = "0.25"
    private var periodPretty = "15 MIN"
    // private var firstRun = true
    private let prefTokenSector = "LIGHTNING_SECTOR"
    private let prefTokenPeriod = "LIGHTNING_PERIOD"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(productClicked))
        timeButton = ToolbarIcon(self, #selector(timeClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, timeButton, shareButton]).items
        image = TouchImage(self, toolbar)
        initializePreferences()
        getContent()
    }

    func initializePreferences() {
        sector = Utility.readPref(prefTokenSector, sector)
        period = Utility.readPref(prefTokenPeriod, period)
        sectorPretty = UtilityLightning.getSectorLabel(sector)
        periodPretty = UtilityLightning.getTimeLabel(period)
    }

    override func getContent() {
        sectorPretty = UtilityLightning.getSectorLabel(sector)
        periodPretty = UtilityLightning.getTimeLabel(period)
        productButton.title = sectorPretty
        timeButton.title = periodPretty
        Utility.writePref(prefTokenSector, sector)
        Utility.writePref(prefTokenPeriod, period)
//        DispatchQueue.global(qos: .userInitiated).async {
//            let bitmap = UtilityLightning.getImage(self.sector, self.period)
//            DispatchQueue.main.async { self.display(bitmap) }
//        }
        _ = FutureBytes(UtilityLightning.getImageUrl(self.sector, self.period), self.display)
    }

    private func display(_ bitmap: Bitmap) {
        // if firstRun {
        image.setBitmap(bitmap)
//            firstRun = false
//        } else {
//            image.updateBitmap(bitmap)
//        }
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, title: "Region Selection", productButton, UtilityLightning.sectors, sectorChanged)
    }

    @objc func timeClicked() {
        _ = ObjectPopUp(self, title: "Time Selection", timeButton, UtilityLightning.times, timeChanged)
    }

    func sectorChanged(_ idx: Int) {
        // firstRun = true
        sectorPretty = UtilityLightning.sectors[idx]
        sector = UtilityLightning.getSector(sectorPretty)
        getContent()
    }

    func timeChanged(_ index: Int) {
        periodPretty = UtilityLightning.times[index]
        period = UtilityLightning.getTime(periodPretty)
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
