/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerWPCMPD: UIwXViewController {

    var bitmaps = [Bitmap]()
    var txtArr = [String]()
    var mpdNumber = ""
    var text = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        mpdNumber = ActVars.WPCMPDNo
        if mpdNumber != "" {
            ActVars.WPCMPDNo = ""
        }
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var mpdList = [String]()
            if self.mpdNumber == "" {
                let dataAsString = (MyApplication.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php").getHtml()
                mpdList = dataAsString.parseColumn(">MPD #(.*?)</a></strong>")
            } else {
                mpdList = [self.mpdNumber]
            }
            mpdList.forEach {
                let imgUrl = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + $0 + ".gif"
                self.text = UtilityDownload.getTextProduct("WPCMPD" + $0)
                self.txtArr.append(self.text)
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
                if !self.bitmaps.isEmpty {
                    self.bitmaps.enumerated().forEach {
                        let imgObject = ObjectImage(self.stackView, $1)
                        imgObject.addGestureRecognizer(
                            UITapGestureRecognizerWithData(
                                data: $0,
                                target: self,
                                action: #selector(self.imgClicked(sender:))
                            )
                        )
                    }
                    if self.bitmaps.count == 1 {
                        _ = ObjectTextView(self.stackView, self.text)
                    }
                }
                self.view.bringSubview(toFront: self.toolbar)
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.TEXTVIEWText = self.txtArr[sender.data]
        self.goToVC("textviewer")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, text)
    }
}
