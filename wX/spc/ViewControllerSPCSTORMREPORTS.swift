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

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let lsrButton = ObjectToolbarIcon(title: "LSR by WFO", self, #selector(self.lsrClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, lsrButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView)
        objDatePicker = ObjectDatePicker(stackView)
        objDatePicker.datePicker.addTarget(self, action: #selector(self.onDateChanged(sender:)), for: .valueChanged)
        image = ObjectImage(self.stackView)
        self.view.addSubview(toolbar)
        imageUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + ActVars.spcStormReportsDay + ".gif"
        textUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + ActVars.spcStormReportsDay  + ".csv"
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(self.imageUrl)
            bitmap.url = self.imageUrl
            self.html = self.textUrl.getHtml()
            self.stormReports = UtilitySPCStormReports.processData(self.html.split(MyApplication.newline))
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.image.addGestureRecognizer(
                    UITapGestureRecognizerWithData(
                        target: self,
                        action: #selector(self.imgClicked(sender:))
                    )
                )
                self.stormReports.enumerated().forEach {
                    let tv = ObjectTextView(self.stackView, $1.text)
                    if $1.text == "Tornado Reports" || $1.text == "Wind Reports" || $1.text == "Hail Reports" {
                        tv.color = UIColor.blue
                    }
                    tv.addGestureRecognizer(UITapGestureRecognizerWithData($0, self, #selector(self.gotoMap(sender:))))
                }
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
        ActVars.webViewShowProduct = false
        ActVars.webViewUseUrl = true
        ActVars.webViewUrl = UtilityMap.genMapURL(
            self.stormReports[sender.data].lat,
            self.stormReports[sender.data].lon,
            "10"
        )
        self.goToVC("webview")
    }

    @objc func onDateChanged(sender: UIDatePicker) {
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let components = objDatePicker.datePicker.calendar.dateComponents([.day, .month, .year],
                                                                          from: objDatePicker.datePicker.date as Date)
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
}
