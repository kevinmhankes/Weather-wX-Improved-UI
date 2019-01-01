/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCAWARN: NSObject {

    private let stackView: UIStackView
    private let uiv: UIViewController
    private var provCode = "ca"
    var bitmap = Bitmap()
    private var dataAsString = ""
    private var locWarning = ""
    private var locWatch = ""
    private var locStatement = ""
    private let provL = ""
    private var listLocUrl = [String]()
    private var listLocName = [String]()
    private var listLocWarning = [String]()
    private var listLocWatch = [String]()
    private var listLocStatement = [String]()
    let provList = [
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

    private let provToCodeMap = [
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

    init(_ uiv: UIViewController, _ stackView: UIStackView) {
        self.uiv = uiv
        self.stackView = stackView
    }

    func getData() {
        if self.provCode == "ca" {
            bitmap = Bitmap("http://weather.gc.ca/data/warningmap/canada_e.png")
        } else {
            bitmap = Bitmap("http://weather.gc.ca/data/warningmap/" + self.provCode + "_e.png")
        }
        if self.provCode == "ca" {
            dataAsString = ("http://weather.gc.ca/warnings/index_e.html").getHtml()
        } else {
            dataAsString = ("http://weather.gc.ca/warnings/index_e.html?prov=" + self.provCode).getHtml()
        }
        self.listLocUrl = dataAsString
            .parseColumn("<tr><td><a href=\"(.*?)\">.*?</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocName = dataAsString
            .parseColumn("<tr><td><a href=\".*?\">(.*?)</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocWarning = dataAsString
            .parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocWatch = dataAsString
            .parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?<td>.*?</td>.*?<tr>")
        self.listLocStatement = dataAsString
            .parseColumn("<tr><td><a href=\".*?\">.*?</a></td>.*?<td>.*?</td>.*?<td>.*?</td>.*?<td>(.*?)</td>.*?<tr>")
    }

    func showData() {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        _ = ObjectImage(stackView, bitmap)
        self.listLocWarning.enumerated().forEach { index, _ in
            locWarning = self.listLocWarning[index]
            locWatch = self.listLocWatch[index]
            locStatement = self.listLocStatement[index]
            if locWarning.contains("href") {
                locWarning += "(Warning)"
                locWarning = locWarning.replaceAll("</.*?>", "")
                locWarning = locWarning.replaceAll("<.*?>", "")
            }
            if locWatch.contains("href") {
                locWatch += "(Watch)"
                locWatch = locWatch.replaceAll("</.*?>", "")
                locWatch = locWatch.replaceAll("<*?>>", "")
            }
            if locStatement.contains("href") {
                locStatement += "(Statement)"
                locStatement = locStatement.replaceAll("</.*?>", "")
                locStatement = locStatement.replaceAll("<.*?>", "")
            }
            var text = provL.uppercased() + ": " + self.listLocName[index] + " "
                + locWarning  + " " + locWatch  + " " + locStatement
            text = text.replaceAllRegexp("<.*?>", "")
            text = text.replaceAllRegexp("&#160;", "")
            text = text.replaceAllRegexp("\n", "")
            let tvObj = ObjectTextView(stackView, text)
            tvObj.addGestureRecognizer(UITapGestureRecognizerWithData(index, uiv, #selector(gotoWarning(sender:))))
        }
        _ = ObjectCALegal(stackView)
    }

    func getWarningUrl(_ index: Int) -> String {
        return "http://weather.gc.ca" + listLocUrl[index]
    }

    @objc func gotoWarning(sender: UITapGestureRecognizerWithData) {}

    var count: String {
        return String(listLocUrl.count)
    }

    func setProv(_ prov: String) {
        provCode = provToCodeMap[prov] ?? ""
    }
}
