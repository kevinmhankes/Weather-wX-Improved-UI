/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerCARADAR: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var cloudButton = ObjectToolbarIcon()
    var index = 8
    var rid = "WSO"
    var url = "https://weather.gc.ca/data/satellite/goes_wcan_visible_100.jpg"
    var mosaicShown = false
    var startFromMosaic = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let radarButton = ObjectToolbarIcon(self, .radar, #selector(radarClicked))
        cloudButton = ObjectToolbarIcon(self, .cloud, #selector(cloudClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                flexBarButton,
                productButton,
                cloudButton,
                radarButton,
                animateButton
            ]
        ).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        url = Utility.readPref("CA_LAST_RID_URL", url)
        if ActVars.caRadarProv == "" {
            rid = Utility.readPref("CA_LAST_RID", rid)
        } else {
            rid = String(ActVars.caRadarProv)
            mosaicShown = true
        }
        if !RadarPreferences.wxoglRememberLocation {
            rid = Location.rid
        }
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var bitmap: Bitmap
            if ActVars.caRadarImageType == "radar" {
                bitmap = UtilityCanadaImg.getRadarBitmapOptionsApplied(self.rid, "")
            } else {
                bitmap = Bitmap(self.url)
            }
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = self.rid
                if !self.startFromMosaic {
                    editor.putString("CA_LAST_RID", self.rid)
                    editor.putString("CA_LAST_RID_URL", self.url)
                }
                if UtilityCanadaImg.mosaicRids.contains(self.rid) {
                    self.mosaicShown = true
                } else {
                    self.mosaicShown = false
                }
            }
        }
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Site Selection", productButton, UtilityCanadaImg.caRids, self.productChanged(_:))
    }

    func productChanged(_ index: Int) {
        ActVars.caRadarImageType = "radar"
        rid = UtilityCanadaImg.caRids[index].split(":")[0]
        self.getContent()
    }

    func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func animateClicked() {
        _ = ObjectPopUp(self, "Select animation:", animateButton, ["short", "long"], self.getAnimation(_:))
    }

    func getAnimation(_ frameCnt: String) {
        var animDrawable = AnimationDrawable()
        DispatchQueue.global(qos: .userInitiated).async {
            if ActVars.caRadarImageType == "radar" {
                if !self.mosaicShown {
                    animDrawable = UtilityCanadaImg.getRadarAnimOptionsApplied(self.rid, frameCnt)
                } else {
                    animDrawable = UtilityCanadaImg.getRadarMosaicAnimation(self.rid, frameCnt)
                }
            } else {
                animDrawable = UtilityCanadaImg.getGOESAnim(self.url)
            }
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    @objc func cloudClicked() {
        _ = ObjectPopUp(self, "Product Selection", cloudButton, UtilityCanadaImg.names, self.cloudChanged(_:))
    }

    func cloudChanged(_ prod: Int) {
        ActVars.caRadarImageType = "vis"
        url = UtilityCanadaImg.urls[prod]
        self.getContent()
    }

    @objc func radarClicked() {
        ActVars.caRadarImageType = "radar"
        self.getContent()
    }
}
