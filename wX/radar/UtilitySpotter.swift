/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilitySpotter {

    static var spotterList = [Spotter]()
    static var reportsList = [SpotterReports]()
    static var initialized = false
    static var currentTime: CLong = 0
    static var currentTimeSec: CLong = 0
    static var refreshIntervalSec: CLong = 0
    static var lastRefresh: CLong = 0
    static var refreshLocMin = RadarPreferences.radarDataRefreshInterval
    static var lat = [Double]()
    static var lon = [Double]()

    static func getSpotterData() -> [Spotter] {
        currentTime = UtilityTime.currentTimeMillis()
        currentTimeSec = currentTime / 1000
        refreshIntervalSec = refreshLocMin * 60
        if (currentTimeSec > (lastRefresh + refreshIntervalSec)) || !initialized {
            spotterList = []
            reportsList = []
            var latAl = [String]()
            var lonAl = [String]()
            var html = "https://www.spotternetwork.org/feeds/csv.txt".getHtmlSep()
            let reportData = html.replaceAll(".*?#storm reports", "")
            processReportsData(reportData)
            html = html.replaceAll("#storm reports.*?$", "")
            let htmlArr = html.split(MyApplication.newline)
            var tmpArr = [String]()
            htmlArr.forEach {
                tmpArr = $0.split(";;")
                if tmpArr.count > 15 {
                    spotterList.append(
                        Spotter(
                            tmpArr[14],
                            tmpArr[15],
                            tmpArr[4],
                            tmpArr[5],
                            tmpArr[3],
                            tmpArr[11],
                            tmpArr[10],
                            tmpArr[0]
                        )
                    )
                    latAl.append(tmpArr[4])
                    lonAl.append(tmpArr[5])
                }
            }
            if latAl.count == lonAl.count {
                lat = []
                lon = []
                latAl.indices.forEach {
                    lat.append(Double(latAl[$0]) ?? 0.0 )
                    lon.append(-1.0 * (Double(lonAl[$0]) ?? 0.0))
                }
            } else {
                lat = []
                lon = []
                lat.append(0.0)
                lon.append(0.0)
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
        return spotterList
    }

    static func processReportsData(_ text: String) {
        let lines = text.split(MyApplication.newline)
        var tmpArr = [String]()
        lines.forEach {
            tmpArr = $0.split(";;")
            if tmpArr.count > 10 && tmpArr.count < 16 && !tmpArr[0].hasPrefix("#") {
                reportsList.append(
                    SpotterReports(
                        tmpArr[9],
                        tmpArr[10],
                        tmpArr[5],
                        tmpArr[6],
                        tmpArr[8],
                        tmpArr[0],
                        tmpArr[3],
                        tmpArr[2],
                        tmpArr[7]
                    )
                )
            }
        }
    }
}
