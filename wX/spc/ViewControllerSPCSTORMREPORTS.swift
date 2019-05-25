/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCSTORMREPORTS: UIwXViewController {

    var image = ObjectImage()
    var objDatePicker: ObjectDatePicker!
    var stormReports = [StormReport]()
    var html = ""
    var date = ""
    var imageUrl = ""
    var textUrl = ""
    var bitmap = Bitmap()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let lsrButton = ObjectToolbarIcon(title: "LSR by WFO", self, #selector(lsrClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, lsrButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView)
        self.displayPreContent()
        self.view.addSubview(toolbar)
        imageUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + ActVars.spcStormReportsDay + ".gif"
        textUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + ActVars.spcStormReportsDay  + ".csv"
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmap = Bitmap(self.imageUrl)
            self.bitmap.url = self.imageUrl
            self.html = self.textUrl.getHtml()
            self.stormReports = UtilitySpcStormReports.processData(self.html.split(MyApplication.newline))
            DispatchQueue.main.async {
               self.displayContent()
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.imageViewerUrl = self.imageUrl
        self.goToVC("imageviewer")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, [self.image.bitmap], self.html)
    }

    @objc func gotoMap(sender: UITapGestureRecognizerWithData) {
        ActVars.mapKitLat = self.stormReports[sender.data].lat
        ActVars.mapKitLon = self.stormReports[sender.data].lon
        ActVars.mapKitRadius = 20000.0
        self.goToVC("mapkitview")
    }

    @objc func onDateChanged(sender: UIDatePicker) {
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let components = objDatePicker.datePicker.calendar.dateComponents(
            [.day, .month, .year],
            from: objDatePicker.datePicker.date as Date
        )
        let day = String(format: "%02d", components.day!)
        let month = String(format: "%02d", components.month!)
        let year = String(components.year!).substring(2)
        date = "\(year)\(month)\(day)"
        imageUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + date + "_rpts.gif"
        textUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + date  + "_rpts.csv"
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(objDatePicker.datePicker)
        stackView.addArrangedSubview(image.img)
        self.getContent()
    }

    @objc func lsrClicked() {
        self.goToVC("lsrbywfo")
    }

    private func displayPreContent() {
        objDatePicker = ObjectDatePicker(stackView)
        objDatePicker.datePicker.addTarget(self, action: #selector(onDateChanged(sender:)), for: .valueChanged)
        image = ObjectImage(self.stackView)
    }

    private func displayContent() {
        self.image.setBitmap(bitmap)
        self.image.addGestureRecognizer(
            UITapGestureRecognizerWithData(
                target: self,
                action: #selector(imgClicked(sender:))
            )
        )
        self.stormReports.enumerated().forEach {
            _ = ObjectCardStormReportItem(
                self.stackView,
                $1,
                UITapGestureRecognizerWithData($0, self, #selector(gotoMap(sender:)))
            )
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayPreContent()
                self.displayContent()
            }
        )
    }
}
