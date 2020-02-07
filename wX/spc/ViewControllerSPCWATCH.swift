/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSPCWATCH: UIwXViewController {
    
    var bitmaps = [Bitmap]()
    var listOfText = [String]()
    var spcWatchNumber = ""
    var playButton = ObjectToolbarIcon()
    var text = ""
    let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        spcWatchNumber = ActVars.spcWatchNumber
        if spcWatchNumber != "" {
            ActVars.spcWatchNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var mcdList = [String]()
            //var mcdTxt = ""
            if self.spcWatchNumber == "" {
                let dataAsString = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
                mcdList = dataAsString.parseColumn("[om] Watch #([0-9]*?)</a>")
            } else {
                mcdList = [self.spcWatchNumber]
            }
            mcdList.forEach {
                let number = String(format: "%04d", Int($0) ?? 0)
                let imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + number + "_radar.gif"
                self.text = UtilityDownload.getTextProduct("SPCWAT" + number)
                self.listOfText.append(self.text)
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.textViewText = self.listOfText[sender.data]
        self.goToVC("textviewer")
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }
    
    @objc func playClicked() {
        UtilityActions.playClicked(text, synth, playButton)
    }
    
    private func displayContent() {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape() && self.bitmaps.count == 1
        #if targetEnvironment(macCatalyst)
            tabletInLandscape = self.bitmaps.count == 1
        #endif
        //tabletInLandscape = false
        if tabletInLandscape {
            stackView.axis = .horizontal
            stackView.alignment = .firstBaseline
        }
        var views = [UIView]()
        if self.bitmaps.count > 0 {
            self.bitmaps.enumerated().forEach {
                /*let objectImage = ObjectImage(
                    self.stackView,
                    $1,
                    UITapGestureRecognizerWithData($0, self, #selector(self.imgClicked(sender:)))
                )
                self.text += self.listOfText[$0]
                objectImage.img.accessibilityLabel = self.listOfText[$0]
                objectImage.img.isAccessibilityElement = true
                views += [objectImage.img]*/
                
                if tabletInLandscape {
                    let objectImage = ObjectImage(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(imageClicked(sender:))),
                        widthDivider: 2
                    )
                    self.text += self.listOfText[$0]
                    objectImage.img.accessibilityLabel = self.listOfText[$0]
                    objectImage.img.isAccessibilityElement = true
                    views += [objectImage.img]
                } else {
                    let objectImage = ObjectImage(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(imageClicked(sender:)))
                    )
                    self.text += self.listOfText[$0]
                    objectImage.img.accessibilityLabel = self.listOfText[$0]
                    objectImage.img.isAccessibilityElement = true
                    views += [objectImage.img]
                }
            }
            if self.bitmaps.count == 1 {
                //_ = ObjectTextView(self.stackView, mcdTxt)
                if tabletInLandscape {
                    _ = ObjectTextView(self.stackView, self.text, widthDivider: 2)
                } else {
                    _ = ObjectTextView(self.stackView, self.text)
                }
            }
        } else {
            let message = "No active watches"
            let objectTextView = ObjectTextView(self.stackView, message)
            objectTextView.tv.isAccessibilityElement = true
            views += [objectTextView.tv]
            objectTextView.tv.accessibilityLabel = message
        }
        self.view.bringSubviewToFront(self.toolbar)
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
