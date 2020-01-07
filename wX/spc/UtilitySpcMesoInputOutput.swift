/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySpcMesoInputOutput {

    static func getImage(_ product: String, _ sector: String) -> Bitmap {
        let prefModel = "SPCMESO"
        let showRadar = Utility.readPref(prefModel + "_SHOW_RADAR", "false").hasPrefix("t")
        let showOutlook = Utility.readPref(prefModel + "_SHOW_OUTLOOK", "false").hasPrefix("t")
        let showWatwarn = Utility.readPref(prefModel + "_SHOW_WATWARN", "false").hasPrefix("t")
        let showTopo = Utility.readPref(prefModel + "_SHOW_TOPO", "false").hasPrefix("t")
        var layers = [Bitmap]()
        var layersRad = [Bitmap]()
        var gifUrl = ""
        let baseUrl = MyApplication.nwsSPCwebsitePrefix + "/exper/mesoanalysis/s"
        let radarImgUrl = baseUrl + sector + "/" + "rgnlrad" + "/" + "rgnlrad" + ".gif"
        let outlookImgUrl = baseUrl + sector + "/" + "otlk" + "/" + "otlk" + ".gif"
        let watwarnImgUrl = baseUrl + sector + "/" + "warns" + "/" + "warns" + ".gif"
        let topoImgUrl = baseUrl + sector + "/" + "topo" + "/" + "topo" + ".gif"
        if UtilitySpcMeso.imgSf.contains(product) && !showRadar {
            gifUrl = "_sf.gif"
        } else {
            gifUrl = ".gif"
        }
        let imgUrl = baseUrl + sector + "/" + product + "/" + product + gifUrl
        let bitmap = Bitmap(imgUrl)
        if showRadar && product != "1kmv" {
            if showTopo {
                layersRad.append(Bitmap(topoImgUrl))
            }
            let bitmapradar = Bitmap(radarImgUrl)
            layersRad.append(bitmapradar)
            layersRad.append(bitmap)
            if showOutlook {
                layersRad.append(Bitmap(outlookImgUrl))
            }
            if showWatwarn {
                layersRad.append(Bitmap(watwarnImgUrl))
            }
            return UtilityImg.layerDrawableToBitmap(layersRad)
        } else {
            if showTopo {
                layers.append(Bitmap(topoImgUrl))
            }
            layers.append(bitmap)
            if showOutlook {
                layers.append(Bitmap(outlookImgUrl))
            }
            if showWatwarn {
                layers.append(Bitmap(watwarnImgUrl))
            }
            return UtilityImg.layerDrawableToBitmap(layers)
        }
    }

    static func getAnimation(_ sector: String, _ product: String, _ frameCount: Int) -> AnimationDrawable {
        var imgUrl = ""
        var bitmaps = [Bitmap]()
        let html = (MyApplication.nwsSPCwebsitePrefix
            + "/exper/mesoanalysis/new/archiveviewer.php?sector=19&parm=pmsl").getHtml()
        let timeList = html.parseColumn("dattim\\[[0-9]{1,2}\\].*?=.*?([0-9]{8})")
        if timeList.count > frameCount {
            stride(from: (frameCount - 1), to: 0, by: -1).forEach {
                imgUrl = MyApplication.nwsSPCwebsitePrefix + "/exper/mesoanalysis/s"
                    + sector + "/" + product + "/" + product + "_" + timeList[$0] + ".gif"
                bitmaps.append(UtilityImg.getBitmapAddWhiteBG(imgUrl))
            }
        }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps, UtilityImg.getAnimInterval())
    }
}
