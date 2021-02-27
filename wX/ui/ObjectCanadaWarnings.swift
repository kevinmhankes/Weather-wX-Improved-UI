/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCanadaWarnings: NSObject {

    private let uiv: UIwXViewController
    private var provinceCode = "ca"
    var bitmap = Bitmap()
    private var listLocUrl = [String]()
    private var listLocName = [String]()
    private var listLocWarning = [String]()
    private var listLocWatch = [String]()
    private var listLocStatement = [String]()
    let provinces = [
        "Canada",
        "Alberta",
        "British Columbia",
        "Manitoba",
        "New Brunswick",
        "Newfoundland and Labrador",
        "Nova Scotia",
        "Northwest Territories",
        "Nunavut",
        "Ontario - South",
        "Ontario - North",
        "Prince Edward Island",
        "Quebec - South",
        "Quebec - North",
        "Saskatchewan",
        "Yukon"
    ]
    private let provinceToCode = [
        "Canada": "ca",
        "Alberta": "ab",
        "British Columbia": "bc",
        "Manitoba": "mb",
        "New Brunswick": "nb",
        "Newfoundland and Labrador": "nl",
        "Nova Scotia": "ns",
        "Northwest Territories": "nt",
        "Nunavut": "nu",
        "Ontario - South": "son",
        "Ontario - North": "non",
        "Prince Edward Island": "pei",
        "Quebec - South": "sqc",
        "Quebec - North": "nqc",
        "Saskatchewan": "sk",
        "Yukon": "yt"
    ]

    init(_ uiv: UIwXViewController) {
        self.uiv = uiv
    }

    func getData() {
        if self.provinceCode == "ca" {
            bitmap = Bitmap(GlobalVariables.canadaEcSitePrefix + "/data/warningmap/canada_e.png")
        } else {
            bitmap = Bitmap(GlobalVariables.canadaEcSitePrefix + "/data/warningmap/" + self.provinceCode + "_e.png")
        }
        var html: String
        if self.provinceCode == "ca" {
            html = (GlobalVariables.canadaEcSitePrefix + "/warnings/index_e.html").getHtml()
        } else {
            html = (GlobalVariables.canadaEcSitePrefix + "/warnings/index_e.html?prov=" + self.provinceCode).getHtml()
        }
        self.listLocUrl = html.parseColumn("<tr><td><a href=\"(.*?)\">.*?</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocName = html.parseColumn("<tr><td><a href=\".*?\">(.*?)</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocWarning = html.parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocWatch = html.parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocStatement = html.parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?<tr>")
    }

    func showData() {
        uiv.stackView.removeViews()
        _ = ObjectImage(uiv.stackView, bitmap)
        self.listLocWarning.indices.forEach { index in
            var locWarning = self.listLocWarning[index]
            var locWatch = self.listLocWatch[index]
            var locStatement = self.listLocStatement[index]
            if locWarning.contains("href") {
                locWarning = locWarning.parse("class=.wb-inv.>(.*?)</span>")
                locWarning = locWarning.replaceAll("</.*?>", "")
                locWarning = locWarning.replaceAll("<.*?>", "")
            }
            if locWatch.contains("href") {
                locWatch = locWatch.parse("class=.wb-inv.>(.*?)</span>")
                locWatch = locWatch.replaceAll("</.*?>", "")
                locWatch = locWatch.replaceAll("<*?>>", "")
            }
            if locStatement.contains("href") {
                locStatement = locStatement.parse("class=.wb-inv.>(.*?)</span>")
                locStatement = locStatement.replaceAll("</.*?>", "")
                locStatement = locStatement.replaceAll("<.*?>", "")
            }
            let province = listLocUrl[index].parse("report_e.html.([a-z]{2}).*?")
            var text = province.uppercased() + ": " + locWarning  + " " + locWatch  + " " + locStatement
            text = text.replaceAllRegexp("<.*?>", "")
            text = text.replaceAllRegexp("&#160;", "")
            text = text.replaceAllRegexp("\n", "")
            let objectTextView = ObjectTextView(
                uiv.stackView,
                text,
                UITapGestureRecognizerWithData(index, uiv, #selector(goToWarning(sender:)))
            )
            objectTextView.tv.isSelectable = false
        }
        _ = ObjectCanadaLegal(uiv.stackView)
    }

    func getWarningUrl(_ index: Int) -> String {
        GlobalVariables.canadaEcSitePrefix + listLocUrl[index]
    }

    @objc func goToWarning(sender: UITapGestureRecognizerWithData) {}

    var count: String { String(listLocUrl.count) }

    func setProvince(_ province: String) {
        provinceCode = provinceToCode[province] ?? ""
    }
}
