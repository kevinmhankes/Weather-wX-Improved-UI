/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityArray {

    static func joinArrayWithDelim(_ stringList: [String], _ delim: String ) -> String {
        var string = ""
        stringList.forEach {string += delim + $0}
        return string
    }
}
