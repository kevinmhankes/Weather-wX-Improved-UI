/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let radarButton = ObjectToolbarIcon(self, .radar, #selector(radarClicked))
        cloudButton = ObjectToolbarIcon(self, .cloud, #selector(cloudClicked))
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            productButton,
                                            cloudButton,
                                            radarButton,
                                            animateButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        url = preferences.getString("CA_LAST_RID_URL", url)
        if ActVars.CARADARprov == "" {
            rid = preferences.getString("CA_LAST_RID", rid)
        } else {
            rid = String(ActVars.CARADARprov)
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
            if ActVars.CARADARimgType=="radar" {
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
        let alert = ObjectPopUp(self, "Site Selection", productButton)
        UtilityCanadaImg.caRids.enumerated().forEach { index, rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in
                self.productChanged(prod: index)})
            )
        }
        alert.finish()
    }

    func productChanged(prod: Int) {
        ActVars.CARADARimgType = "radar"
        rid = UtilityCanadaImg.caRids[prod].split(":")[0]
        self.getContent()
    }

    func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func animateClicked() {
        let alert = ObjectPopUp(self, "Select animation:", animateButton)
        ["short", "long"].forEach {cnt in alert.addAction(UIAlertAction(title: cnt, style: .default, handler: {_ in
            self.getAnimation(cnt)}))
        }
        alert.finish()
    }

    func getAnimation(_ frameCnt: String) {
        var animDrawable = AnimationDrawable()
        DispatchQueue.global(qos: .userInitiated).async {
            if ActVars.CARADARimgType=="radar" {
                if !self.mosaicShown {
                    animDrawable = UtilityCanadaImg.getRadarAnimOptionsApplied(self.rid, frameCnt)
                } else {
                    animDrawable = UtilityCanadaImg.getRadarMosaicAnimation(self.rid, frameCnt)
                }
            } else {animDrawable =  UtilityCanadaImg.getGOESAnim(self.url)}
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    @objc func cloudClicked() {
        let alert = ObjectPopUp(self, "Product Selection", cloudButton)
        UtilityCanadaImg.names.enumerated().forEach { index, rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in self.cloudChanged(index)}))
        }
        alert.finish()
    }

    func cloudChanged(_ prod: Int) {
        ActVars.CARADARimgType = "vis"
        url = UtilityCanadaImg.urls[prod]
        self.getContent()
    }

    @objc func radarClicked() {
        ActVars.CARADARimgType = "radar"
        self.getContent()
    }
}
