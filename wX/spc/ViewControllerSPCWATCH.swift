/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCWATCH: UIwXViewController {

    var bitmaps = [Bitmap]()
    var txtArr = [String]()
    var SPCWATno = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        SPCWATno = ActVars.SPCWATNo
        if SPCWATno != "" {ActVars.SPCWATNo = ""}
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var mcdList = [String]()
            var mcdTxt = ""
            if self.SPCWATno=="" {
                let dataAsString = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
                mcdList = dataAsString.parseColumn("[om] Watch #([0-9]*?)</a>")
            } else {
                mcdList = [self.SPCWATno]
            }
            mcdList.forEach {
                let number = String(format: "%04d", Int($0) ?? 0)
                let imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + number + "_radar.gif"
                mcdTxt = UtilityDownload.getTextProduct("SPCWAT" + number)
                self.txtArr.append(mcdTxt)
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
                if self.bitmaps.count>0 {
                    self.bitmaps.enumerated().forEach {
                        let objImage = ObjectImage(self.stackView, $1)
                        objImage.addGestureRecognizer(UITapGestureRecognizerWithData(data: $0,
                                                                                     target: self,
                                                                                     action: #selector(self.imgClicked(sender:))))
                    }
                    if self.bitmaps.count == 1 {_ = ObjectTextView(self.stackView, mcdTxt)}
                } else {
                    _ = ObjectTextView(self.stackView, "No active watches")
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
        UtilityShare.shareImage(self, sender, bitmaps)
    }
}
