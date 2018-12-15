/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

// NWS GOES Image viewer
//
// Arguments
// 1: "nws"
// 2: sector ( specific WFO in lower case or as example "CEUS" )
// 3: product ( optional, "wv" as example )
//

class ViewControllerNHCGOES: UIwXViewController {

    var image = ObjectTouchImageView()
    var wfoChoosen = true
    var sector = ""
    var satSector = ""
    var imageType = ""
    var productButton = ObjectToolbarIcon()
    let mesoImg = Set<String>()
    let overlayImg = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(imageTypeClicked))
        let animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, animateButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        sector = ActVars.NHCGOESid
        imageType = ActVars.NHCGOESimageType
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityNHC.getImage(self.sector, self.imageType)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = self.imageType
            }
        }
    }

    func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityNHC.getAnimation(self.sector, self.imageType, frameCount)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    @objc func animateClicked() {
        let alert = ObjectPopUp(self, "Select number of animation frames:", productButton)
        [10, 20, 30].forEach { count in
            alert.addAction(UIAlertAction(String(count), { _ in self.getAnimation(count)}))
        }
        alert.finish()
    }

    @objc func imageTypeClicked() {
        let alert = ObjectPopUp(self, "Image Type Selection", productButton)
        UtilityNHC.imageType.forEach {
            let imageTypeCode = $0.split(":")
            alert.addAction(UIAlertAction($0, {_ in self.imageTypeChanged(imageTypeCode[0])}))
        }
        alert.finish()
    }

    func imageTypeChanged(_ rid: String) {
        imageType = rid
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
}
