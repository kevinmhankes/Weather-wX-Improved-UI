/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCanadaWarnings: NSObject {
    
    private var uiv: UIwXViewController
    private var provinceCode = "ca"
    var bitmap = Bitmap()
    private var html = ""
    private var locWarning = ""
    private var locWatch = ""
    private var locStatement = ""
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
            bitmap = Bitmap(MyApplication.canadaEcSitePrefix + "/data/warningmap/canada_e.png")
        } else {
            bitmap = Bitmap(MyApplication.canadaEcSitePrefix + "/data/warningmap/" + self.provinceCode + "_e.png")
        }
        if self.provinceCode == "ca" {
            let url = MyApplication.canadaEcSitePrefix + "/warnings/index_e.html"
            html = (url).getHtml()
        } else {
            html = (MyApplication.canadaEcSitePrefix + "/warnings/index_e.html?prov=" + self.provinceCode).getHtml()
        }
        self.listLocUrl = html.parseColumn("<tr><td><a href=\"(.*?)\">.*?</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocName = html.parseColumn("<tr><td><a href=\".*?\">(.*?)</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocWarning = html.parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocWatch = html.parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocStatement = html.parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?<tr>")
    }
    
    func showData() {
        uiv.stackView.subviews.forEach { $0.removeFromSuperview() }
        _ = ObjectImage(uiv.stackView, bitmap)
        self.listLocWarning.enumerated().forEach { index, _ in
            locWarning = self.listLocWarning[index]
            locWatch = self.listLocWatch[index]
            locStatement = self.listLocStatement[index]
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
        _ = ObjectCALegal(uiv.stackView)
    }
    
    func getWarningUrl(_ index: Int) -> String {
        return MyApplication.canadaEcSitePrefix + listLocUrl[index]
    }
    
    @objc func goToWarning(sender: UITapGestureRecognizerWithData) {}
    
    var count: String {
        return String(listLocUrl.count)
    }
    
    func setProvince(_ province: String) {
        provinceCode = provinceToCode[province] ?? ""
    }
}
