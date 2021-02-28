/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcCanadaRadar: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var animateButton = ObjectToolbarIcon()
    private var cloudButton = ObjectToolbarIcon()
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
        let shareButton = ObjectToolbarIcon(self, .share, #selector(share))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                cloudButton,
                radarButton,
                animateButton,
                shareButton
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
        getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap: Bitmap
            if self.caRadarImageType == "radar" {
                bitmap = UtilityCanadaImg.getRadarBitmapOptionsApplied(self.radarSite, "")
            } else {
                bitmap = Bitmap(self.url)
            }
            DispatchQueue.main.async { self.display(bitmap) }
        }
    }
    
    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
        productButton.title = radarSite
        if !startFromMosaic {
           Utility.writePref("CA_LAST_RID", radarSite)
           Utility.writePref("CA_LAST_RID_URL", url)
        }
        if UtilityCanadaImg.mosaicSectors.contains(radarSite) {
           mosaicShown = true
        } else {
           mosaicShown = false
        }
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, title: "Site Selection", productButton, UtilityCanadaImg.radarSites, productChanged(_:))
    }
    
    func productChanged(_ index: Int) {
        caRadarImageType = "radar"
        radarSite = UtilityCanadaImg.radarSites[index].split(":")[0]
        getContent()
    }

    @objc func animateClicked() {
        _ = ObjectPopUp(self, title: "Select animation:", animateButton, ["short", "long"], getAnimation(_:))
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
            DispatchQueue.main.async { self.image.startAnimating(animDrawable) }
        }
    }
    
    @objc func cloudClicked() {
        _ = ObjectPopUp(self, cloudButton, UtilityCanadaImg.names, cloudChanged(_:))
    }
    
    func cloudChanged(_ prod: Int) {
        caRadarImageType = "vis"
        url = UtilityCanadaImg.urls[prod]
        getContent()
    }
    
    @objc func radarClicked() {
        caRadarImageType = "radar"
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
