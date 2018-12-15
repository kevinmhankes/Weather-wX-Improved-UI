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
            let nwsRadarMosaicSectorLabelCurrent = UtilityUSImgNWSMosaic.getSectorFromState(getStateFromRid())
            index = UtilityUSImgNWSMosaic.sectors.index(of: nwsRadarMosaicSectorLabelCurrent) ?? 0
        }
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityUSImgNWSMosaic.get(UtilityUSImgNWSMosaic.sectors[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityUSImgNWSMosaic.labels[self.index]
                if !self.isLocal {
                    editor.putInt("NWSMOSAIC_PARAM_LAST_USED", self.index)
                }
            }
        }
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    // FIXME
    // add an init for ObjectPopup that accepts a List and calls finish method when done
    // refactor code below so that productChanged sends the list item not the index and
    // the reciever will convert as needed to index
    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton, UtilityUSImgNWSMosaic.labels, self.productChanged(_:))
        //UtilityUSImgNWSMosaic.labels.forEach { rid in
        //    alert.addAction(UIAlertAction(rid, {_ in self.productChanged(rid)}))
        //}
        //alert.finish()
    }

    func productChanged(_ product: String) {
        self.index = UtilityUSImgNWSMosaic.labels.index(of: product)!
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func animateClicked() {
        let alert = ObjectPopUp(self, "Select number of animation frames:", animateButton)
        [5, 10, 20, 30].forEach { count in
            alert.addAction(UIAlertAction(title: String(count), style: .default, handler: { _ in
                self.getAnimation(count)}))
        }
        alert.finish()
    }

    func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityUSImgNWSMosaic.getAnimation(UtilityUSImgNWSMosaic.sectors[self.index],
                                                                        frameCount)
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
