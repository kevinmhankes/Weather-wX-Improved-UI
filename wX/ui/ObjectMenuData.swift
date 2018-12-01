/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectMenuData {

	var params = [String]()
   	var paramLabels = [String]()
    var objTitles = [ObjectMenuTitle]()

    init(_ objTitles: [ObjectMenuTitle], _ params: [String], _ paramLabels: [String]) {
        self.objTitles = objTitles
        self.params = params
		self.paramLabels = paramLabels
	}
}
