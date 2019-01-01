/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectForecastPackage {

    var objCC = ObjectForecastPackageCurrentConditions()

    convenience init( _ objCC: ObjectForecastPackageCurrentConditions) {
        self.init()
        self.objCC = objCC
    }
}
