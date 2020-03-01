/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcFireSummary: UIwXViewController {
    
    private var bitmaps = [Bitmap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let statusButton = ObjectToolbarIcon(title: "SPC Fire Weather Outlooks", self, nil)
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                statusButton,
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
            self.bitmaps = UtilitySpcFireOutlook.urls.map {Bitmap($0)}
            DispatchQueue.main.async {
                self.refreshViews()
                self.displayContent()
            }
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        let vc = vcSpcFireOutlook()
        vc.dayIndex = sender.data
        self.goToVC(vc)
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }
    
    private func displayContent() {
        var views = [UIView]()
        var dayNumber = 0
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() {
            imagesPerRow = 3
        }
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
            let objectImage = ObjectImage(
                stackView,
                image,
                UITapGestureRecognizerWithData(imageIndex, self, #selector(imageClicked(sender:))),
                widthDivider: imagesPerRow
            )
            objectImage.img.isAccessibilityElement = true
            views += [objectImage.img]
            dayNumber += 1
            objectImage.img.accessibilityLabel = "day " + String(dayNumber)
            imageCount += 1
        }
        self.accessibilityElements = views
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
