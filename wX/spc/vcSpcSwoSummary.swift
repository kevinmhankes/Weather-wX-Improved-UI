/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcSwoSummary: UIwXViewController {
    
    private var bitmaps = [Bitmap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        getContent()
    }
    
    @objc func willEnterForeground() {
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps = (1...3).map { UtilitySpcSwo.getImageUrls(String($0), getAllImages: false)[0] }
            self.bitmaps += UtilitySpcSwo.getImageUrls("48", getAllImages: true)
            DispatchQueue.main.async {
                self.refreshViews()
                self.displayContent()
            }
        }
    }
    
    private func displayContent() {
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 4
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = 4
        #endif
        self.bitmaps.enumerated().forEach { imageIndex, image in
            let stackView: UIStackView
            if imageCount % imagesPerRow == 0 {
                let objectStackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                imageStackViewList.append(objectStackView)
                stackView = objectStackView.view
                self.stackView.addArrangedSubview(stackView)
            } else {
                stackView = imageStackViewList.last!.view
            }
            _ = ObjectImage(
                stackView,
                image,
                UITapGestureRecognizerWithData(imageIndex, self, #selector(imageClicked(sender:))),
                widthDivider: imagesPerRow
            )
            imageCount += 1
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        switch sender.data {
        case 0...2:
            let vc = vcSpcSwo()
            vc.spcSwoDay = String(sender.data + 1)
            self.goToVC(vc)
        case 3...7:
            let vc = vcSpcSwo()
            vc.spcSwoDay = "48"
            self.goToVC(vc)
        default:
            break
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
