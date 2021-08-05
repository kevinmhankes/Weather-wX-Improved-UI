// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ObjectNhcRegionSummary {

    var urls: [String]

    init(_ region: NhcOceanEnum) {
        switch region {
        case NhcOceanEnum.ATL:
            urls = [
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_0d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_2d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_5d0.png"
            ]
        case NhcOceanEnum.EPAC:
            urls = [
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_0d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_2d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_5d0.png"
            ]
        case NhcOceanEnum.CPAC:
            urls = [
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_0d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_2d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_5d0.png"
            ]
        }
    }
}
