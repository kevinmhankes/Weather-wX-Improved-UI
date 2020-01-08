/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerWpcRainfallDiscussion: UIwXViewController {

    var bitmaps = [Bitmap]()
    var listOfText = [String]()
    var urls = [String]()
    var playListButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    var spcMcdNumber = ""
    var text = ""
    let synth = AVSpeechSynthesizer()
    var product = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton, playListButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let number = Int(ActVars.wpcRainfallDay)! - 1
            let imgUrl = UtilityWpcRainfallOutlook.urls[number]
            self.product = UtilityWpcRainfallOutlook.productCode[number]
            //self.text = UtilityDownload.getTextProduct(self.product)
            let textUrl = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + ActVars.wpcRainfallDay
            let html = textUrl.getHtmlSep()
            self.text = UtilityString.extractPre(html).removeSingleLineBreaks()
            self.listOfText.append(self.text)
            self.urls.append(imgUrl)
            self.bitmaps.append(Bitmap(imgUrl))
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.textViewText = self.listOfText[sender.data]
        self.goToVC("textviewer")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, text)
    }

    @objc func playClicked() {
        UtilityActions.playClicked(text, synth, playButton)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, text, self, playListButton)
    }

    private func displayContent() {
        var views = [UIView]()
        text = ""
        if self.bitmaps.count > 0 {
            self.bitmaps.enumerated().forEach {
                let objectImage = ObjectImage(
                    self.stackView,
                    $1,
                    UITapGestureRecognizerWithData($0, self, #selector(imgClicked(sender:)))
                )
                objectImage.img.accessibilityLabel = listOfText[$0]
                objectImage.img.isAccessibilityElement = true
                views.append(objectImage.img)
                text += listOfText[$0]
            }
            if self.bitmaps.count == 1 {
                let objectTextView = ObjectTextView(self.stackView, self.text)
                objectTextView.tv.isAccessibilityElement = true
                views.append(objectTextView.tv)
            }
        } else {
            let message = "No active SPC MCDs"
            let objectTextView = ObjectTextView(self.stackView, message)
            objectTextView.tv.isAccessibilityElement = true
            views += [objectTextView.tv]
            objectTextView.tv.accessibilityLabel = message
        }
        self.view.bringSubviewToFront(self.toolbar)
        scrollView.accessibilityElements = views
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
