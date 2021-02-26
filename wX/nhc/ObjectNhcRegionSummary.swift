/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectNhcRegionSummary {

    var urls: [String]
    var titles: [String]
    var bitmaps = [Bitmap]()
    private var replaceString: String
    private var baseUrl: String

    init(_ region: NhcOceanEnum) {
        switch region {
        case NhcOceanEnum.ATL:
            titles = [
                "Atlantic Tropical Cyclones and Disturbances ",
                "ATL: Two-Day Graphical Tropical Weather Outlook",
                "ATL: Five-Day Graphical Tropical Weather Outlook"
            ]
            urls = [
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_0d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_2d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_atl_5d0.png"
            ]
            replaceString = "NHC Atlantic Wallet"
            baseUrl = GlobalVariables.nwsNhcWebsitePrefix + "/nhc_at"
        case NhcOceanEnum.EPAC:
            titles = [
                "EPAC Tropical Cyclones and Disturbances ",
                "EPAC: Two-Day Graphical Tropical Weather Outlook",
                "EPAC: Five-Day Graphical Tropical Weather Outlook"
            ]
            urls = [
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_0d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_2d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_pac_5d0.png"
            ]
            replaceString = "NHC Eastern Pacific Wallet"
            baseUrl = GlobalVariables.nwsNhcWebsitePrefix + "/nhc_ep"
        case NhcOceanEnum.CPAC:
            titles = [
                "CPAC Tropical Cyclones and Disturbances ",
                "CPAC: Two-Day Graphical Tropical Weather Outlook",
                "CPAC: Five-Day Graphical Tropical Weather Outlook"
            ]
            urls = [
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_0d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_2d0.png",
                GlobalVariables.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_5d0.png"
            ]
            replaceString = ""
            baseUrl = ""
        }
    }

    func getImages() {
        bitmaps = urls.map { $0.getImage() }
    }

    func getTitle(_ index: Int) -> [String] {
        [urls[index], titles[index]]
    }
}
