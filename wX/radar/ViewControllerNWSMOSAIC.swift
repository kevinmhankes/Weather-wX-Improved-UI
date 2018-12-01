/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerNWSMOSAIC: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var index = 8
    var isLocal = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, animateButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        index = preferences.getInt("NWSMOSAIC_PARAM_LAST_USED", index)
        if ActVars.NWSMOSAICtype=="local" {
            ActVars.NWSMOSAICtype = ""
            isLocal = true
            let nwsRadarMosaicSectorLabelCurrent = UtilityUSImgNWSMosaic.getNwsSectorFromState(getStateFromRid())
            index = UtilityUSImgNWSMosaic.sectors.index(of: nwsRadarMosaicSectorLabelCurrent) ?? 0
        }
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityUSImgNWSMosaic.nwsMosaic(UtilityUSImgNWSMosaic.sectors[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityUSImgNWSMosaic.LABELS[self.index]
                if !self.isLocal {editor.putInt("NWSMOSAIC_PARAM_LAST_USED", self.index)}
            }
        }
    }

    @objc func willEnterForeground() {self.getContent()}

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        UtilityUSImgNWSMosaic.LABELS.enumerated().forEach { i, rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in self.productChanged(i)}))
        }
        alert.finish()
    }

    func productChanged(_ index: Int) {
        self.index = index
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, image.bitmap)}

    @objc func animateClicked() {
        let alert = ObjectPopUp(self, "Select number of animation frames:", animateButton)
        ["5", "10", "20", "30"].forEach { cnt in alert.addAction(UIAlertAction(title: cnt, style: .default, handler: {_ in self.getAnimation(cnt)}))}
        alert.finish()
    }

    func getAnimation(_ frameCnt: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityUSImgNWSMosaic.nwsMosaicAnimation(UtilityUSImgNWSMosaic.sectors[self.index], frameCnt)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    func getStateFromRid() -> String {
        let ridLoc = preferences.getString("RID_LOC_" + Location.rid, "")
        let nwsLocationArr = ridLoc.split(",")
        return nwsLocationArr[0]
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityUSImgNWSMosaic.sectors)
        getContent()
    }
}
