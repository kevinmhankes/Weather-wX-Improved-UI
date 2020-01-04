/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

// Data file - https://www.wpc.ncep.noaa.gov/basicwx/coded_srp.txt
// Decoder - https://www.wpc.ncep.noaa.gov/basicwx/read_coded_fcst_bull.shtml
// Image - https://www.wpc.ncep.noaa.gov/basicwx/basicwx_ndfd.php

/*
 
 CODED SURFACE FRONTAL POSITIONS FORECAST
 NWS WEATHER PREDICTION CENTER COLLEGE PARK MD
 1117 AM EST FRI DEC 20 2019
 
 SURFACE PROG VALID 201912201800Z
 HIGHS 1043 5010795 1036 3750811 1036 4061092 1026 3121240
 LOWS 1000 5301138 1021 4610937 1005 4931216 1005 4151308 1021 3351009
 STNRY 2310761 2230786 2210811 2220827 2220838
 STNRY 4050725 4010749 3990769 4020794 4050809 4080816
 WARM 4610937 4610923 4560905 4480890 4340873 4220854 4140836
 4070815
 COLD 4620937 4570948 4570961 4600977
 WARM 5251080 5251064 5171042 4951027 4791013 4680995 4600978
 COLD 4931216 4701239 4501262 4391277 4251295
 STNRY 4151307 4001313 3851326
 STNRY 5251080 5241105 5271130 5301139
 STNRY 5301139 5331149 5401174 5451199 5531223 5631241
 TROF 2220879 2530886 2750886 2970879
 TROF 4581084 4441085 4251096
 TROF 3941043 3671043 3391055
 TROF 4600938 4350945 4160956 3940974 3760988 3630996 3511002
 3251012 2991024 2871026
 WARM 4161307 4211300 4261294
 TROF 5361348 5171317 4971300 4801292
 TROF 5241139 4991127 4721125
 TROF 3171112 2901103 2711092 2491077
 
 SURFACE PROG VALID 201912210000Z
 HIGHS 1035 3971077 1042 4900775 1023 3181216
 LOWS 1005 5011189 1005 4051297 1000 5271115 1021 4740914 1022 3420997
 COLD 4730916 4690932 4700953 4730971
 STNRY 2310757 2280774 2250791 2260806 2300825
 
 */

class UtilityWpcFronts {
    static var initialized = false
    static var lastRefresh: CLong = 0
    static var refreshLocMin = RadarPreferences.radarDataRefreshInterval * 2
    static var pressureCenters = [PressureCenter]()
    static var fronts = [Fronts]()
    
    static func addColdFrontTriangles(_ front: inout Fronts, _ tokens: [String]) {
        let length = 0.4 // size of trianle
        var startIndex = 0
        var indexIncrement = 1
        if front.type == FrontTypeEnum.OCFNT {
            startIndex = 1
            indexIncrement = 2
        }
        for index in stride(from: startIndex, to: tokens.count - 1, by: indexIncrement) {
            //for (int index = startIndex; index < tokens.length; index += indexIncrement) {
            let coordinates = parseLatLon(tokens[index])
            if index < (tokens.count - 1) {
                let coordinates2 = parseLatLon(tokens[index + 1])
                let distance = UtilityMath.distanceOfLine(coordinates[0], coordinates[1], coordinates2[0], coordinates2[1])
                var numberOfTriangles = distance / length
                numberOfTriangles.round(.towardZero)
                // construct two lines which will consist of adding 4 points
                for pointNumber in stride(from: 1, to: numberOfTriangles - 1, by: 4) {
                    //for (int pointNumber = 1; pointNumber < numberOfTriangles; pointNumber += 2) {
                    let x1 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * pointNumber) / distance
                    let y1 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * pointNumber) / distance
                    let x3 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * (pointNumber + 1)) / distance
                    let y3 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * (pointNumber + 1)) / distance
                    let p2 = UtilityMath.computeTipPoint(x1, y1, x3, y3, true)
                    let x2 = p2[0]
                    let y2 = p2[1]
                    front.coordinates.append(LatLon(x1, y1))
                    front.coordinates.append(LatLon(x2, y2))
                    front.coordinates.append(LatLon(x2, y2))
                    front.coordinates.append(LatLon(x3, y3))
                }
            }
        }
    }
    
    static func addWarmFrontSemicircles(_ front: inout Fronts, _ tokens: [String]) {
        var length = 0.4 // size of trianle
        var startIndex = 0
        var indexIncrement = 1
        if front.type == FrontTypeEnum.OCFNT {
            startIndex = 2
            indexIncrement = 2
            length = 0.2
        }
        for index in stride(from: startIndex, to: tokens.count - 1, by: indexIncrement) {
            //for (int index = startIndex; index < tokens.length; index += indexIncrement) {
            let coordinates = parseLatLon(tokens[index])
            if index < (tokens.count - 1) {
                let coordinates2 = parseLatLon(tokens[index + 1])
                let distance = UtilityMath.distanceOfLine(coordinates[0], coordinates[1], coordinates2[0], coordinates2[1])
                var numberOfTriangles = (distance / length)
                numberOfTriangles.round(.towardZero)
                // construct two lines which will consist of adding 4 points
                for pointNumber in stride(from: 1, to: numberOfTriangles - 1, by: 4) {
                    //for (int pointNumber = 1; pointNumber < numberOfTriangles; pointNumber += 4) {
                    let x1 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * pointNumber) / distance
                    let y1 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * pointNumber) / distance
                    let center1 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * (pointNumber + 0.5)) / distance
                    let center2 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * (pointNumber + 0.5)) / distance
                    let x3 = coordinates[0] + ((coordinates2[0] - coordinates[0]) * length * (pointNumber + 1)) / distance
                    let y3 = coordinates[1] + ((coordinates2[1] - coordinates[1]) * length * (pointNumber + 1)) / distance
                    front.coordinates.append(LatLon(x1, y1))
                    let slices = 20
                    let step = Double.pi / Double(slices)
                    let rotation = 1.0
                    let xDiff = x3 - x1
                    let yDiff = y3 - y1
                    let angle = atan2(yDiff, xDiff) * 180.0 / Double.pi
                    let sliceStart = Int((Double(slices) * angle) / 180.0)
                    for i in stride(from: sliceStart, to: slices + sliceStart, by: 1) {
                        //for (int i = sliceStart; i <= slices + sliceStart; i++) {
                        let x = rotation * length * cos(step * Double(i)) + center1
                        let y = rotation * length * sin(step * Double(i)) + center2
                        front.coordinates.append(LatLon(x, y))
                        front.coordinates.append(LatLon(x, y))
                    }
                    front.coordinates.append(LatLon(x3, y3))
                }
            }
        }
    }
    
    static func addFrontDataStnryWarm(_ front: inout Fronts, _ tokens: [String]) {
        tokens.enumerated().forEach { index, _ in
            let coordinates = parseLatLon(tokens[index])
            if index != 0 && index != (tokens.count - 1) {
                front.coordinates.append(LatLon(coordinates[0], coordinates[1]))
            }
        }
    }
    
    static func addFrontData(_ front: inout Fronts, _ tokens: [String]) {
        tokens.enumerated().forEach { index, _ in
            let coordinates = parseLatLon(tokens[index])
            front.coordinates.append(LatLon(coordinates[0], coordinates[1]))
            if index != 0 && index != (tokens.count - 1) {
                front.coordinates.append(LatLon(coordinates[0], coordinates[1]))
            }
        }
    }
    
    static func parseLatLon(_ string: String) -> [Double] {
        if string.count != 7 {
            return [0.0, 0.0]
        } else {
            let lat = Double(string.substring(0, 2) + "." + string.substring(2, 3)) ?? 0.0
            var lon = 0.0
            // TODO FIXME need to make sure this is working
            let index = string.index(string.startIndex, offsetBy: 3)
            if String(string[index]) == "0" {
                lon = Double(string.substring(4, 6) + "." + string.substring(6, 7)) ?? 0.0
            } else {
                lon = Double(string.substring(3, 6) + "." + string.substring(6, 7)) ?? 0.0
            }
            return [lat, lon]
        }
    }
    
    static func get() {
        let currentTime1 = UtilityTime.currentTimeMillis()
        let currentTimeSec = currentTime1 / 1000
        let refreshIntervalSec = refreshLocMin * 60
        var fetchData = (currentTimeSec > (lastRefresh + refreshIntervalSec)) || !initialized;
        //fetchData = true;
        if fetchData {
            pressureCenters = [];
            fronts = [];
            let urlBlob = MyApplication.nwsWPCwebsitePrefix + "/basicwx/coded_srp.txt";
            var html = urlBlob.getHtmlSep();
            html = html.replaceAll(MyApplication.newline, MyApplication.sep);
            let timestamp = html.parseFirst("SURFACE PROG VALID ([0-9]{12}Z)");
            Utility.writePref("WPC_FRONTS_TIMESTAMP", timestamp);
            html = html.parseFirst("SURFACE PROG VALID [0-9]{12}Z(.*?)" +
                MyApplication.sep +
                " " +
                MyApplication.sep)
            html = html.replaceAll(MyApplication.sep, MyApplication.newline)
            let lines = html.split(MyApplication.newline)
            //for (int index = 0; index < lines.length; index++) {
            lines.enumerated().forEach { index, _ in
                var data = lines[index]
                if (index < lines.count - 1) {
                    let charIndex = lines[index + 1].index(lines[index + 1].startIndex, offsetBy: 0)
                    if (lines[index + 1][charIndex] != "H"
                        && lines[index + 1][charIndex] != "L"
                        && lines[index + 1][charIndex] != "C"
                        && lines[index + 1][charIndex] != "S"
                        && lines[index + 1][charIndex] != "O"
                        && lines[index + 1][charIndex] != "T"
                        && lines[index + 1][charIndex] != "W") {
                        data += lines[index + 1];
                    }
                }
                var tokens = data.trim().split(" ")
                if (tokens.count > 1) {
                    let type = tokens[0]
                    tokens.remove(at: 0)
                    switch (type) {
                    case "HIGHS":
                        //for (int index = 0; index < tokens.length; index += 2) {
                        for index in stride(from: 0, to: tokens.count - 1, by: 2) {
                            let coordinates = parseLatLon(tokens[index + 1])
                            pressureCenters.append(PressureCenter(PressureCenterTypeEnum.HIGH,
                                                                  tokens[index], coordinates[0], coordinates[1]))
                        }
                        break;
                    case "LOWS":
                        //for (int index = 0; index < tokens.length; index += 2) {
                        for index in stride(from: 0, to: tokens.count - 1, by: 2) {
                            let coordinates = parseLatLon(tokens[index + 1])
                            pressureCenters.append(PressureCenter(PressureCenterTypeEnum.LOW,
                                                                  tokens[index], coordinates[0], coordinates[1]))
                        }
                        break
                    case "COLD":
                        var front = Fronts(FrontTypeEnum.COLD)
                        addFrontData(&front, tokens)
                        addColdFrontTriangles(&front, tokens)
                        //addWarmFrontSemicircles(front, tokens)
                        fronts.append(front)
                        break;
                    case "STNRY":
                        var front = Fronts(FrontTypeEnum.STNRY)
                        addFrontData(&front, tokens)
                        fronts.append(front)
                        var frontStWarm = Fronts(FrontTypeEnum.STNRY_WARM)
                        addFrontDataStnryWarm(&frontStWarm, tokens)
                        fronts.append(frontStWarm)
                        break;
                    case "WARM":
                        var front = Fronts(FrontTypeEnum.WARM)
                        addFrontData(&front, tokens)
                        addWarmFrontSemicircles(&front, tokens)
                        fronts.append(front)
                        break;
                    case "TROF":
                        var front = Fronts(FrontTypeEnum.TROF)
                        addFrontData(&front, tokens)
                        fronts.append(front)
                        break;
                    case "OCFNT":
                        var front = Fronts(FrontTypeEnum.OCFNT)
                        addFrontData(&front, tokens)
                        addColdFrontTriangles(&front, tokens)
                        addWarmFrontSemicircles(&front, tokens)
                        fronts.append(front)
                        break
                    default:
                        break
                    }
                }
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
