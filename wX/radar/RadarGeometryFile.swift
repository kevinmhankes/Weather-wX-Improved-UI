/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

// work in progress - currently not used

import Foundation

class RadarGeometryFile {

    var relativeBuffer = MemoryBuffer()
    //var byteData: ByteData
    var count: Int
    var fileName: String
    var initialized = false
    var preferenceToken: String
    var showItem: Bool
    var showItemDefault: Bool

    init(_ fileName: String, _ count: Int, _ preferenceToken: String, _ showItemDefault: Bool) {
        self.fileName = fileName
        self.count = count
        self.preferenceToken = preferenceToken
        self.showItemDefault = showItemDefault

        if showItemDefault {
            showItem = Utility.readPref(preferenceToken, "true").hasPrefix("t")
        } else {
            showItem = Utility.readPref(preferenceToken, "false").hasPrefix("t")
        }
        if showItem {
            //initialize()
        }
    }

    func initializeIfNeeded() {
        if showItemDefault {
            showItem = Utility.readPref(preferenceToken, "true").hasPrefix("t")
        } else {
            showItem = Utility.readPref(preferenceToken, "false").hasPrefix("t")
        }
        if showItem && !initialized {
            //initialize()
        }
    }

    /*factory RadarGeometryFile.byType(RadarGeometryFileType type) {
     switch (type) {
     case RadarGeometryFileType.countyLines:
     return RadarGeometryFile(
     "county.bin", 212992, "RADAR_SHOW_COUNTY", true);
     break;
     case RadarGeometryFileType.highways:
     return RadarGeometryFile("hwv4.bin", 862208, "COD_HW_DEFAULT", true);
     break;
     case RadarGeometryFileType.stateLines:
     return RadarGeometryFile(
     "statev2.bin", 205748, "RADAR_SHOW_STATELINES", true);
     break;
     case RadarGeometryFileType.rivers:
     return RadarGeometryFile(
     "lakesv3.bin", 503812, "COD_LAKES_DEFAULT", false);
     break;
     case RadarGeometryFileType.highwaysExtended:
     return RadarGeometryFile(
     "hwv4ext.bin", 770048, "RADAR_HW_ENH_EXT", false);
     break;
     case RadarGeometryFileType.canadaLines:
     return RadarGeometryFile("ca.bin", 161792, "RADAR_CANADA_LINES", false);
     break;
     case RadarGeometryFileType.mexicoLines:
     return RadarGeometryFile("mx.bin", 151552, "RADAR_MEXICO_LINES", false);
     break;
     default:
     return RadarGeometryFile(
     "statev2.bin", 205748, "RADAR_SHOW_STATELINES", true);
     break;
     }
     }*/

    /* func initialize() {
     if (!initialized) {
     relativeBuffer = MemoryBuffer(count * 4);
     relativeBuffer.byteData = rootBundle.load("assets/res/" + fileName);
     byteData = ByteData(relativeBuffer.byteData.lengthInBytes);
     initialized = true;
     }
     }*/

    func initialize(_ addData: Bool) {
        if !initialized {
            let floatSize: Float = 0.0
            var newArray = [UInt8](repeating: 0, count: count * 4)
            let path = Bundle.main.path(forResource: fileName, ofType: "bin")
            let data = NSData(contentsOfFile: path!)
            data!.getBytes(&newArray, length: MemoryLayout.size(ofValue: floatSize) * count)
            if addData {
                relativeBuffer.appendArray(newArray)
            } else {
                relativeBuffer.copy(newArray)
            }
            initialized = true
        }
    }

    /*static func checkForInitialization() {
     for (var index = 0; index < RadarGeometryFileType.values.length; index++) {
     await RadarGeometryFile.byTypes[RadarGeometryFileType.values[index]]
     .initializeIfNeeded();
     }
     }*/

    static var byTypes = [RadarGeometryFileType: RadarGeometryFile]()

    /*static func instantiateAll() {
     RadarGeometryFileType.values.forEach((v) {
     byTypes[v] = RadarGeometryFile.byType(v);
     });
     }*/
}
