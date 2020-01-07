/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette {

    static func getColorMapStringFromDisk(_ product: String, _ code: String) -> String {
        var cmFileInt = ""
        var text: String?
        switch product {
        case "94":
            switch code {
            case "DKenh": cmFileInt = R.Raw.colormaprefdkenh
            case "CUST":  cmFileInt = R.Raw.colormaprefcode
            case "CODE":  cmFileInt = R.Raw.colormaprefcode
            case "NSSL":  cmFileInt = R.Raw.colormaprefnssl
            case "NWSD":  cmFileInt = R.Raw.colormaprefnwsd
            case "NWS":  cmFileInt = R.Raw.colormaprefnws
            case "COD":   cmFileInt = R.Raw.colormaprefcodenh
            case "CODENH":cmFileInt = R.Raw.colormaprefcodenh
            case "MENH":  cmFileInt = R.Raw.colormaprefmenh
            case "GREEN": cmFileInt = R.Raw.colormaprefgreen
            case "AF":    cmFileInt = R.Raw.colormaprefaf
            case "EAK":   cmFileInt = R.Raw.colormaprefeak
            default:      text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "99":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormapbvcod
            case "CODENH": cmFileInt = R.Raw.colormapbvcod
            case "AF":     cmFileInt = R.Raw.colormapbvaf
            case "EAK":    cmFileInt = R.Raw.colormapbveak
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "135":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap135cod
            case "CODENH": cmFileInt = R.Raw.colormap135cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "161":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap161cod
            case "CODENH": cmFileInt = R.Raw.colormap161cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "163":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap163cod
            case "CODENH": cmFileInt = R.Raw.colormap163cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "159":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap159cod
            case "CODENH": cmFileInt = R.Raw.colormap159cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "134":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap134cod
            case "CODENH": cmFileInt = R.Raw.colormap134cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "165":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap165cod
            case "CODENH": cmFileInt = R.Raw.colormap165cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        case "172":
            switch code {
            case "COD":    cmFileInt = R.Raw.colormap172cod
            case "CODENH": cmFileInt = R.Raw.colormap172cod
            default:       text = Utility.readPref("RADAR_COLOR_PAL_" + product + "_" + code, "")
            }
        default: break
        }
        if text == nil {
            return UtilityIO.readTextFile(cmFileInt)
        } else {
            return text!
        }
    }
}
