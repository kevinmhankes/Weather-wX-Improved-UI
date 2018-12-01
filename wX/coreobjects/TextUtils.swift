/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class TextUtils {

    class func join(_ delim: String, _ data: Set<String>) -> String {
        var string = ""
        data.forEach {string += $0 + delim}
	    return string
	}

    class func join(_ delim: String, _ data: [String]) -> String {
        var string = ""
        data.forEach {string += $0 + delim}
        return string
    }

    class func split(_ data: String, _ delim: String) -> [String] {
        var stringList = data.split(delim)
        stringList.removeLast()
        return stringList
    }
}
