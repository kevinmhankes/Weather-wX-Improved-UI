/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCSWOSUMMARY: UIwXViewController {

    var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps = (1...3).map {UtilitySpcSwo.getImageUrls(String($0), getAllImages: false)[0]}
            self.bitmaps += UtilitySpcSwo.getImageUrls("48", getAllImages: true)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    private func displayContent() {
        let imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        [0, 1, 2, 3].forEach {
            imageStackViewList.append(
                ObjectStackView(
                    UIStackView.Distribution.fill,
                    NSLayoutConstraint.Axis.horizontal,
                    spacing: UIPreferences.stackviewCardSpacing
                )
            )
            self.stackView.addArrangedSubview(imageStackViewList[$0].view)
        }
        self.bitmaps.enumerated().forEach {
            _ = ObjectImage(
                imageStackViewList[$0 / imagesPerRow].view,
                $1,
                UITapGestureRecognizerWithData($0, self, #selector(self.imageClicked(sender:))),
                widthDivider: imagesPerRow
            )
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        switch sender.data {
        case 0...2:
            ActVars.spcswoDay = String(sender.data + 1)
            self.goToVC("spcswo")
        case 3...7:
            ActVars.spcswoDay = "48"
            self.goToVC("spcswo")
        default: break
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
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
