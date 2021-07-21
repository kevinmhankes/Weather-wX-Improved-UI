/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityModels {
    
    static func convertTimeRunToTimeString(_ runStr: String, _ timeStrFunc: String) -> String {
        let timeStr = timeStrFunc.truncate(3)
        let runInt = to.Int(runStr)
        let timeInt = to.Int(timeStr)
        let realTimeGmt = runInt + timeInt
        let offsetFromUtc = UtilityTime.secondsFromUTC()
        let realTime = realTimeGmt + offsetFromUtc / 60 / 60
        var hourOfDay = realTime % 24
        var amPm: String
        if hourOfDay > 11 {
            amPm = "pm"
            if hourOfDay > 12 {
                hourOfDay -= 12
            }
        } else {
            amPm = "am"
        }
        var day = realTime / 24
        if hourOfDay < 0 {
            hourOfDay = 12 + hourOfDay
            amPm = "pm"
            day -= 1
        }
        let date = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date )
        let hourOfDayLocal = calendar.component(.hour, from: date )
        if runInt >= 0 && runInt < -offsetFromUtc/60/60 && (hourOfDayLocal-offsetFromUtc/60/60) >= 24 {
            day += 1
        }
        var futureDay = ""
        switch (dayOfWeek + day) % 7 {
        case 1:
            futureDay = "Sun"
        case 2:
            futureDay = "Mon"
        case 3:
            futureDay = "Tue"
        case 4:
            futureDay = "Wed"
        case 5:
            futureDay = "Thu"
        case 6:
            futureDay = "Fri"
        case 0:
            futureDay = "Sat"
        default:
            break
        }
        return futureDay + "  " + String(hourOfDay) + amPm
    }
    
    static func updateTime(_ run: String, _ modelCurrentTime: String, _ listTime: [String], _ prefix: String) -> [String] {
        var tmpStr = ""
        var run2 = run.replace("Z", "").replace("z", "")
        var listTimeNew = [String]()
        var modelCurrentTime2 = modelCurrentTime.replace("Z", "")
        modelCurrentTime2 = modelCurrentTime2.replace("z", "")
        if modelCurrentTime2 != "" {
            if to.Int(run2) > to.Int(modelCurrentTime2) {
                run2 = String(to.Int(run2) - 24)
            }
            listTime.forEach { value in
                tmpStr = value.split(" ")[0].replace(prefix, "")
                listTimeNew.append(prefix + tmpStr + " " + UtilityModels.convertTimeRunToTimeString(run2, tmpStr))
            }
        }
        return listTimeNew
    }
    
    static func getAnimation(_ om: ObjectModel, _ getImage: (ObjectModel) -> Bitmap) -> AnimationDrawable {
        var bitmaps = [Bitmap]()
        let origTime = om.timeStr
        if om.times.count > 0 {
            (om.timeIndex..<om.times.count).forEach { index in
                om.timeStr = om.times[index].split(" ")[0]
                bitmaps.append(getImage(om))
            }
            om.timeStr = origTime
        }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
}
