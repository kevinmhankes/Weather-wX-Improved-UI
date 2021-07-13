/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class MenuData {

    let params: [String]
    let paramLabels: [String]
    let objTitles: [ObjectMenuTitle]

    init(_ objTitles: [ObjectMenuTitle], _ params: [String], _ paramLabels: [String]) {
        self.objTitles = objTitles
        self.params = params
		self.paramLabels = paramLabels
	}
}
