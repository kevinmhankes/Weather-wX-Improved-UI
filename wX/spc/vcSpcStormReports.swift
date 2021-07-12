/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcStormReports: UIwXViewController {

    private var image = ObjectImage()
    private var objDatePicker: ObjectDatePicker!
    private var stormReports = [StormReport]()
    private var html = ""
    private var date = ""
    private var imageUrl = ""
    private var textUrl = ""
    private var bitmap = Bitmap()
    private var stateCount = [String: Int]()
    private var filterList = [String]()
    private var filter = "All"
    private var filterButton = ToolbarIcon()
    var spcStormReportsDay = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        let lsrButton = ToolbarIcon(title: "LSR by WFO", self, #selector(lsrClicked))
        filterButton = ToolbarIcon(title: "Filter: " + filter, self, #selector(filterClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            filterButton,
            lsrButton,
            shareButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        displayPreContent()
        imageUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".gif"
        textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".csv"
        getContent()
    }

    // do not do anything
    override func willEnterForeground() {
        // self.getContent()
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmap = Bitmap(self.imageUrl)
            self.bitmap.url = self.imageUrl
            self.html = self.textUrl.getHtml()
            self.stormReports = UtilitySpcStormReports.process(self.html.split(GlobalVariables.newline))
            DispatchQueue.main.async { self.display() }
        }
    }

    @objc func imgClicked() {
        Route.imageViewer(self, imageUrl)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, [image.bitmap], html)
    }

    @objc func gotoMap(sender: UITapGestureRecognizerWithData) {
        Route.map(self, stormReports[sender.data].lat, stormReports[sender.data].lon)
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
        date = year + month + day
        imageUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + date + "_rpts.gif"
        textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + date + "_rpts.csv"
        stackView.removeViews()
        stackView.addArrangedSubview(objDatePicker.datePicker)
        stackView.addArrangedSubview(image.img)
        getContent()
    }

    @objc func lsrClicked() {
        let vc = vcLsrByWfo()
        goToVC(vc)
    }

    @objc func filterClicked() {
        _ = ObjectPopUp(
            self,
            title: "Filter Selection",
            filterButton,
            filterList,
            changeFilter(_:)
        )
    }

    private func changeFilter(_ index: Int) {
        filter = filterList[index].split(":")[0]
        filterButton.title = "Filter: " + filter
        stackView.removeViews()
        stackView.addArrangedSubview(objDatePicker.datePicker)
        stackView.addArrangedSubview(image.img)
        display()
    }

    private func displayPreContent() {
        objDatePicker = ObjectDatePicker(stackView)
        objDatePicker.datePicker.addTarget(self, action: #selector(onDateChanged(sender:)), for: .valueChanged)
        image = ObjectImage(stackView)
    }

    private func display() {
        var stateList = [String]()
        filterList = ["All"]
        var tornadoReports = 0
        var windReports = 0
        var hailReports = 0
        var tornadoHeader: ObjectCardBlackHeaderText?
        var windHeader: ObjectCardBlackHeaderText?
        var hailHeader: ObjectCardBlackHeaderText?
        image.setBitmap(bitmap)
        image.addGestureRecognizer(UITapGestureRecognizerWithData(target: self, action: #selector(imgClicked)))
        stormReports.enumerated().forEach { index, stormReport in
            if stormReport.damageHeader != "" {
                switch stormReport.damageHeader {
                case "Tornado Reports":
                    tornadoHeader = ObjectCardBlackHeaderText(self, stormReport.damageHeader)
                case "Wind Reports":
                    windHeader = ObjectCardBlackHeaderText(self, stormReport.damageHeader)
                case "Hail Reports":
                    hailHeader = ObjectCardBlackHeaderText(self, stormReport.damageHeader)
                default:
                    break
                }
            }
            if stormReport.damageHeader == "" && (filter == "All" || filter == stormReport.state) {
                if windHeader == nil {
                    tornadoReports += 1
                } else if hailHeader == nil {
                    windReports += 1
                } else {
                    hailReports += 1
                }
                _ = ObjectCardStormReportItem(
                    stackView,
                    stormReport,
                    UITapGestureRecognizerWithData(index, self, #selector(gotoMap(sender:)))
                )
            }
            if stormReport.state != "" {
                stateList += [stormReport.state]
            }
        }
        if tornadoReports == 0 {
            if tornadoHeader != nil {
                // self.stackView.removeArrangedSubview(tornadoHeader!.view)
            }
        }
        if windReports == 0 {
            if windHeader != nil {
                // self.stackView.removeArrangedSubview(windHeader!.view)
            }
        }
        if hailReports == 0 {
            if hailHeader != nil {
                // self.stackView.removeArrangedSubview(hailHeader!.view)
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
                self.display()
            }
        )
    }
}
