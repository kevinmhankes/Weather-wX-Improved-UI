/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcNhcStorm: UIwXViewController {

    private var productButton = ObjectToolbarIcon()
    private var buttonActionArray = [String]()
    private var url = ""
    private var html = ""
    private var titleS = ""
    private var baseUrl = ""
    private var baseUrlShort = ""
    private var stormId = ""
    private var goesIdImg = ""
    private var goesSector = ""
    private var goesId = ""
    private var imgUrl1 = ""
    private var product = ""
    private var topBitmap = Bitmap()
    private var bitmaps = [Bitmap]()
    private var tv = ObjectTextView()
    private let textProducts = [
        "MIATCP: Public Advisory",
        "MIATCM: Forecast Advisory",
        "MIATCD: Forecast Discussion",
        "MIAPWS: Wind Speed Probababilities"
    ]
    private let stormUrls = [
        "_key_messages.png",
        "WPCQPF_sm2.gif",
        "_earliest_reasonable_toa_34_sm2.png",
        "_most_likely_toa_34_sm2.png",
        "_wind_probs_34_F120_sm2.png",
        "_wind_probs_50_F120_sm2.png",
        "_wind_probs_64_F120_sm2.png"
    ]
    // FIXME create class for these vars
    var nhcStormUrl = ""
    var nhcStormTitle = ""
    var nhcStormImgUrl1 = ""
    var nhcStormImgUrl2 = ""
    var nhcStormWallet = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME redundant vars
        url = nhcStormUrl
        titleS = nhcStormTitle
        imgUrl1 = nhcStormImgUrl1
        let year = UtilityTime.getYear()
        var yearInString = String(year)
        let yearInStringFull = String(year)
        let yearInStringShort = yearInString.substring(2)
        yearInString = yearInString.substring(2, 4)
        baseUrl = imgUrl1.replace(yearInString+"_5day_cone_with_line_and_wind_sm2.png", "")
        baseUrl += yearInString
        stormId = baseUrl.substring(baseUrl.count - 4)
        goesIdImg = stormId.substring(stormId.count - 4, stormId.count - 2)
        stormId = nhcStormWallet
        stormId = stormId.replace("EP0", "EP").replace("AL0", "AL")
        goesSector = stormId.truncate(1)
        goesSector = goesSector.replace("A", "L")  // value is either E or L
        stormId = stormId.replace("AL", "AT")
        goesId = stormId.replace("EP", "").replace("AT", "")
        if goesId.count < 2 {
            goesId = "0" + goesId
        }
        product = "MIATCP" + stormId
        baseUrlShort = baseUrl.replace(yearInStringFull, "") + yearInStringShort
        productButton = ObjectToolbarIcon(title: " Text Prod", self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        _ = ObjectScrollStackView(self, scrollView, stackView)
        self.getContent()
    }

    func getContent() {
        let serial: DispatchQueue = DispatchQueue(label: "joshuatee.wx")
        serial.async {
            self.topBitmap = Bitmap(self.baseUrl + "_5day_cone_with_line_and_wind_sm2.png")
            DispatchQueue.main.async {
                self.displayTopImageContent()
            }
        }
        serial.async {
            self.html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async {
                self.displayTextContent()
            }
        }
        serial.async {
            self.bitmaps.append(UtilityNhc.getImage(self.goesIdImg + self.goesSector, "vis"))
            self.stormUrls.forEach {
                var url = self.baseUrl
                if $0 == "WPCQPF_sm2.gif" {
                    url = self.baseUrlShort
                }
                self.bitmaps.append(Bitmap(url + $0))
            }
            DispatchQueue.main.async {
               self.displayImageContent()
            }
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.bitmaps)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, textProducts, self.productChanged(_:))
    }

    func productChanged(_ product: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product + self.stormId)
            DispatchQueue.main.async {
                let vc = vcTextViewer()
                vc.textViewText = html
                self.goToVC(vc)
            }
        }
    }

    func displayTopImageContent() {
        _ = ObjectImage(self.stackView, topBitmap)
        self.view.bringSubviewToFront(self.toolbar)
    }

    func displayTextContent() {
        tv = ObjectTextView(self.stackView, html)
        self.view.bringSubviewToFront(self.toolbar)
    }

    func displayImageContent() {
        self.bitmaps.filter {($0.isValidForNhc)}.forEach {_ = ObjectImage(self.stackView, $0)}
        self.view.bringSubviewToFront(self.toolbar)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayTopImageContent()
                self.displayTextContent()
                self.displayImageContent()
            }
        )
    }
}
