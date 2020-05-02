/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcCanadaRadar: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var animateButton = ObjectToolbarIcon()
    private var cloudButton = ObjectToolbarIcon()
    private var index = 8
    private var radarSite = "WSO"
    private var url = "https://weather.gc.ca/data/satellite/goes_wcan_visible_100.jpg"
    private var mosaicShown = false
    private var startFromMosaic = false
    var caRadarProvince = ""
    var caRadarImageType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let radarButton = ObjectToolbarIcon(self, .radar, #selector(radarClicked))
        cloudButton = ObjectToolbarIcon(self, .cloud, #selector(cloudClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                cloudButton,
                radarButton,
                animateButton
            ]
        ).items
        image = ObjectTouchImageView(self, toolbar)
        url = Utility.readPref("CA_LAST_RID_URL", url)
        if caRadarProvince == "" {
            radarSite = Utility.readPref("CA_LAST_RID", radarSite)
        } else {
            radarSite = String(caRadarProvince)
            mosaicShown = true
        }
        if !RadarPreferences.wxoglRememberLocation { radarSite = Location.rid }
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var bitmap: Bitmap
            if self.caRadarImageType == "radar" {
                bitmap = UtilityCanadaImg.getRadarBitmapOptionsApplied(self.radarSite, "")
            } else {
                bitmap = Bitmap(self.url)
            }
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = self.radarSite
                if !self.startFromMosaic {
                    Utility.writePref("CA_LAST_RID", self.radarSite)
                    Utility.writePref("CA_LAST_RID_URL", self.url)
                }
                if UtilityCanadaImg.mosaicSectors.contains(self.radarSite) {
                    self.mosaicShown = true
                } else {
                    self.mosaicShown = false
                }
            }
        }
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, title: "Site Selection", productButton, UtilityCanadaImg.radarSites, self.productChanged(_:))
    }
    
    func productChanged(_ index: Int) {
        caRadarImageType = "radar"
        radarSite = UtilityCanadaImg.radarSites[index].split(":")[0]
        self.getContent()
    }
    
    func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func animateClicked() {
        _ = ObjectPopUp(self, title: "Select animation:", animateButton, ["short", "long"], self.getAnimation(_:))
    }
    
    func getAnimation(_ frameCnt: String) {
        var animDrawable = AnimationDrawable()
        DispatchQueue.global(qos: .userInitiated).async {
            if self.caRadarImageType == "radar" {
                if !self.mosaicShown {
                    animDrawable = UtilityCanadaImg.getRadarAnimOptionsApplied(self.radarSite, frameCnt)
                } else {
                    animDrawable = UtilityCanadaImg.getRadarMosaicAnimation(self.radarSite, frameCnt)
                }
            } else {
                animDrawable = UtilityCanadaImg.getGoesAnimation(self.url)
            }
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
    
    @objc func cloudClicked() {
        _ = ObjectPopUp(self, cloudButton, UtilityCanadaImg.names, self.cloudChanged(_:))
    }
    
    func cloudChanged(_ prod: Int) {
        caRadarImageType = "vis"
        url = UtilityCanadaImg.urls[prod]
        self.getContent()
    }
    
    @objc func radarClicked() {
        caRadarImageType = "radar"
        self.getContent()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
