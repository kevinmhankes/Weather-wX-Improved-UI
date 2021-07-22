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
    private var boxImage = ObjectStackView(.fill, .vertical)
    private var boxText = ObjectStackView(.fill, .vertical)

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
        
        stackView.addArrangedSubview(boxImage.get())
        stackView.addArrangedSubview(boxText.get())
        
        boxImage.constrain(self)
        boxText.constrain(self)
        
        displayPreContent()
        imageUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".gif"
        textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".csv"
        getContent()
    }

//    override func willEnterForeground() {
//        self.getContent()
//    }

    // TODO more threads
    override func getContent() {
        _ = FutureVoid(downloadImage, displayImage)
        _ = FutureVoid(downloadText, displayText)
    }

    private func downloadImage() {
        bitmap = Bitmap(imageUrl)
        bitmap.url = imageUrl
    }
    
    private func downloadText() {
        html = textUrl.getHtml()
        stormReports = UtilitySpcStormReports.process(html.split(GlobalVariables.newline))
    }

    @objc func imgClicked() {
        Route.imageViewer(self, imageUrl)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, [image.bitmap], html)
    }

    @objc func gotoMap(sender: GestureData) {
        Route.map(self, stormReports[sender.data].lat, stormReports[sender.data].lon)
    }

    @objc func onDateChanged(_: UIDatePicker) {
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
        boxImage.removeChildren()
        boxImage.addWidget(objDatePicker.datePicker)
        boxImage.addWidget(image.img)
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
//        stackView.removeViews()
//        stackView.addArrangedSubview(objDatePicker.datePicker)
//        stackView.addArrangedSubview(image.img)
        displayImage()
        displayText()
    }

    private func displayPreContent() {
        objDatePicker = ObjectDatePicker(boxImage.get())
        objDatePicker.datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
        image = ObjectImage(boxImage.get())
    }
    
    private func displayImage() {
        image.setBitmap(bitmap)
        image.addGestureRecognizer(GestureData(target: self, action: #selector(imgClicked)))
    }

    private func displayText() {
        boxText.removeChildren()
        
        var stateList = [String]()
        filterList = ["All"]
        var tornadoReports = 0
        var windReports = 0
        var hailReports = 0
        var tornadoHeader: ObjectCardBlackHeaderText?
        var windHeader: ObjectCardBlackHeaderText?
        var hailHeader: ObjectCardBlackHeaderText?

        stormReports.enumerated().forEach { index, stormReport in
            if stormReport.damageHeader != "" {
                switch stormReport.damageHeader {
                case "Tornado Reports":
                    tornadoHeader = ObjectCardBlackHeaderText(boxText.get(), stormReport.damageHeader)
                    tornadoHeader?.constrain(self)
                case "Wind Reports":
                    windHeader = ObjectCardBlackHeaderText(boxText.get(), stormReport.damageHeader)
                    windHeader?.constrain(self)
                case "Hail Reports":
                    hailHeader = ObjectCardBlackHeaderText(boxText.get(), stormReport.damageHeader)
                    hailHeader?.constrain(self)
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
                    boxText.get(),
                    stormReport,
                    GestureData(index, self, #selector(gotoMap(sender:)))
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
            completion: { _ in
                // self.refreshViews()
                // self.displayPreContent()
                self.displayImage()
                self.displayText()
            }
        )
    }
}
