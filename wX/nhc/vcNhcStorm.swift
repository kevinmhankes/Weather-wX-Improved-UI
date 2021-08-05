// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcNhcStorm: UIwXViewController {

    private var productButton = ToolbarIcon()
    private var goesButton = ToolbarIcon()
    private var html = ""
    private var product = ""
    private var bitmaps = [Bitmap]()
    private let textProducts = [
        "MIATCP: Public Advisory",
        "MIATCM: Forecast Advisory",
        "MIATCD: Forecast Discussion",
        "MIAPWS: Wind Speed Probababilities"
    ]
    private let imageUrls = [
        "_5day_cone_with_line_and_wind_sm2.png",
        "_key_messages.png",
        "WPCQPF_sm2.gif",
        "_earliest_reasonable_toa_34_sm2.png",
        "_most_likely_toa_34_sm2.png",
        "_wind_probs_34_F120_sm2.png",
        "_wind_probs_50_F120_sm2.png",
        "_wind_probs_64_F120_sm2.png"
    ]
    var stormData: ObjectNhcStormDetails!
    private var objectImageSummary: ObjectImageSummary!
    private var boxImages = ObjectStackView(.fill, .vertical)
    private var objectTextView: Text!

    override func viewDidLoad() {
        super.viewDidLoad()
        product = "MIATCP" + stormData.binNumber
        productButton = ToolbarIcon(title: " Text Products", self, #selector(productClicked))
        goesButton = ToolbarIcon(self, .cloud, #selector(goesClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, goesButton, productButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        stackView.addLayout(boxImages)
        objectTextView = Text(stackView)
        objectTextView.constrain(scrollView)
        bitmaps = [Bitmap](repeating: Bitmap(), count: 9)
        objectImageSummary = ObjectImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)
        getContent()
    }

    override func getContent() {
        getContentImages()
        _ = FutureVoid({ self.html = UtilityDownload.getTextProduct(self.product) }, display)
    }

    func getContentImages() {
        for (index, imageName) in imageUrls.enumerated() {
            var url = stormData.baseUrl
            if imageName == "WPCQPF_sm2.gif" {
                url.removeLast(2)
            }
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url + imageName) }, { self.display() })
        }
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, textProducts, productChanged)
    }

    func productChanged(_ product: String) {
        Route.wpcText(self, product + stormData.binNumber.uppercased())
    }

    func display() {
        boxImages.removeChildren()
        displayImage()
        displayText()
    }

    func displayText() {
        objectTextView.setText(html)
    }

    func displayImage() {
        objectImageSummary = ObjectImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)
        for (index, url) in imageUrls.enumerated() {
            objectImageSummary.objectImages[index].addGestureRecognizer(GestureData(url, self, #selector(imageClicked)))
        }
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, bitmaps[sender.data].url)
    }

    @objc func goesClicked(sender: UIButton) {
        Route.visNhc(self, stormData.goesUrl)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.display() })
    }
}
