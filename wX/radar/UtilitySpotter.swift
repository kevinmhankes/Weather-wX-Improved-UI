/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySpotter {

    static var spotterList = [Spotter]()
    static var reportsList = [SpotterReports]()
    private static let timer = DownloadTimer("SPOTTER")
    static var lat = [Double]()
    static var lon = [Double]()

    // TODO match kotlin getter "reports", use let
    static func get() -> [Spotter] {
        if timer.isRefreshNeeded() {
            spotterList = []
            reportsList = []
            var latitudeList = [String]()
            var longitudeList = [String]()
            var html = "https://www.spotternetwork.org/feeds/csv.txt".getHtmlSep()
            let reportData = html.replaceAll(".*?#storm reports", "")
            processReports(reportData)
            html = html.replaceAll("#storm reports.*?$", "")
            html.split(GlobalVariables.newline).forEach { line in
                let items = line.split(";;")
                if items.count > 15 {
                    spotterList.append(Spotter(items[14], items[15], LatLon(items[4], items[5]), items[3], items[11], items[10], items[0]))
                    latitudeList.append(items[4])
                    longitudeList.append(items[5])
                }
            }
            if latitudeList.count == longitudeList.count {
                lat = []
                lon = []
                latitudeList.indices.forEach { index in
                    lat.append(Double(latitudeList[index]) ?? 0.0 )
                    lon.append(-1.0 * (Double(longitudeList[index]) ?? 0.0))
                }
            } else {
                lat = []
                lon = []
                lat.append(0.0)
                lon.append(0.0)
            }
        }
        return spotterList
    }

    static func processReports(_ html: String) {
        html.split(GlobalVariables.newline).forEach { line in
            let items = line.split(";;")
            if items.count > 10 && items.count < 16 && !items[0].hasPrefix("#") {
                reportsList.append(SpotterReports(items[9], items[10], LatLon(items[5], items[6]), items[8], items[0], items[3], items[2], items[7]))
            }
        }
    }
}
