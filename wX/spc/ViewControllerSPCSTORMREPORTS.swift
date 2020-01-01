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
    var stateCount = [String: Int]()
    var filterList = [String]()
    var filter = "All"
    var filterButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let lsrButton = ObjectToolbarIcon(title: "LSR by WFO", self, #selector(lsrClicked))
        filterButton = ObjectToolbarIcon(title: "Filter: " + filter, self, #selector(filterClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, filterButton, lsrButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.displayPreContent()
        imageUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + ActVars.spcStormReportsDay + ".gif"
        textUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + ActVars.spcStormReportsDay  + ".csv"
        self.getContent()
    }

    // TODO get onrestart working

    @objc func willEnterForeground() {
        //self.getContent()
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

    @objc func filterClicked() {
        _ = ObjectPopUp(
            self,
            "Filter Selection",
            filterButton,
            filterList,
            self.changeFilter(_:)
        )
    }

    private func changeFilter(_ index: Int) {
        filter = filterList[index].split(":")[0]
        filterButton.title = "Filter: " + filter
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(objDatePicker.datePicker)
        stackView.addArrangedSubview(image.img)
        displayContent()
    }

    private func displayPreContent() {
        objDatePicker = ObjectDatePicker(stackView)
        objDatePicker.datePicker.addTarget(self, action: #selector(onDateChanged(sender:)), for: .valueChanged)
        image = ObjectImage(self.stackView)
    }

    private func displayContent() {
        var stateList = [String]()
        filterList = ["All"]
        self.image.setBitmap(bitmap)
        self.image.addGestureRecognizer(
            UITapGestureRecognizerWithData(
                target: self,
                action: #selector(imgClicked(sender:))
            )
        )
        self.stormReports.enumerated().forEach {
            if $1.damageHeader != "" {
                _ = ObjectCardBlackHeaderText(self.stackView, $1.damageHeader)
            }
            if $1.damageHeader == "" && (filter == "All" || filter == $1.state) {
                _ = ObjectCardStormReportItem(
                    self.stackView,
                    $1,
                    UITapGestureRecognizerWithData($0, self, #selector(gotoMap(sender:)))
                )
            }
            if $1.state != "" {
                stateList += [$1.state]
            }
        }
        let mappedItems = stateList.map { ($0, 1) }
        stateCount = Dictionary(mappedItems, uniquingKeysWith: +)
        let sortedKeys = stateCount.keys.sorted()
        for key in sortedKeys {
            let val = stateCount[key] ?? 0
            filterList += [key + ": " + String(val)]
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
