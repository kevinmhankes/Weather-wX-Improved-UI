/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcNhcStorm: UIwXViewController {
    
    private var productButton = ObjectToolbarIcon()
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
    private var bitmaps = [Bitmap]()
    private let textProducts = [
        "MIATCP: Public Advisory",
        "MIATCM: Forecast Advisory",
        "MIATCD: Forecast Discussion",
        "MIAPWS: Wind Speed Probababilities"
    ]
    private var bitmapsFiltered = [Bitmap]()
    private let stormUrls = [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeEnvironment()
        let statusButton = ObjectToolbarIcon(title: stormData.type + " " + stormData.name + " " + stormData.forTopHeader(), self, nil)
        productButton = ObjectToolbarIcon(title: " Text Prod", self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, statusButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    func initializeEnvironment() {
        let year = UtilityTime.getYear()
        var yearInString = String(year)
        let yearInStringShort = yearInString.substring(2)
        yearInString = yearInString.substring(2, 4)
        baseUrl = stormData.baseUrl
        stormId = baseUrl.substring(baseUrl.count - 4)
        goesIdImg = stormId.substring(stormId.count - 4, stormId.count - 2)
        stormId = stormData.wallet
        stormId = stormId.replace("EP0", "EP").replace("AL0", "AL")
        goesSector = stormId.truncate(1)
        goesSector = goesSector.replace("A", "L")  // value is either E or L
        stormId = stormId.replace("AL", "AT")
        goesId = stormId.replace("EP", "").replace("AT", "")
        if goesId.count < 2 { goesId = "0" + goesId }
        product = "MIATCP" + stormId
        baseUrlShort = "https://www.nhc.noaa.gov/storm_graphics/" + goesId + "/" + stormData.atcf.replaceAll(yearInString, "") + yearInStringShort
    }
    
    override func getContent() {
        bitmaps = []
        self.refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps.append(UtilityNhc.getImage(self.goesIdImg + self.goesSector, "vis"))
            self.stormUrls.forEach { fileName in
                var url = self.baseUrl
                if fileName == "WPCQPF_sm2.gif" { url = self.baseUrlShort }
                self.bitmaps.append(Bitmap(url + fileName))
            }
            self.html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async { self.displayContent() }
        }
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.bitmaps)
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, textProducts, self.productChanged(_:))
    }
    
    func productChanged(_ product: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product + self.stormId)
            DispatchQueue.main.async { Route.textViewer(self, html) }
        }
    }
    
    func displayContent() {
        refreshViews()
        displayImageContent()
        displayTextContent()
    }

    func displayTextContent() {
        let objectTextView = ObjectTextView(self.stackView, html)
        objectTextView.constrain(scrollView)
    }
    
    func displayImageContent() {
        bitmapsFiltered = []
        self.bitmapsFiltered = self.bitmaps.filter { $0.isValidForNhc }
        _ = ObjectImageSummary(self, bitmapsFiltered, imagesPerRowWide: 2)
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        Route.imageViewer(self, bitmapsFiltered[sender.data].url)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in self.displayContent() }
        )
    }
}
