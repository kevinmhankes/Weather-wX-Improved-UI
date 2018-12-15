/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySPCMESOInputOutput {

    static func getImage(_ product: String, _ sector: String) -> Bitmap {
        let prefModel = "SPCMESO"
        let showRadar = preferences.getString(prefModel + "_SHOW_RADAR", "false").hasPrefix("t")
        let showOutlook = preferences.getString(prefModel + "_SHOW_OUTLOOK", "false").hasPrefix("t")
        let showWatwarn = preferences.getString(prefModel + "_SHOW_WATWARN", "false").hasPrefix("t")
        let showTopo = preferences.getString(prefModel + "_SHOW_TOPO", "false").hasPrefix("t")
        var layers = [Drawable]()
        var layersRad = [Drawable]()
        var gifUrl = ""
        let baseUrl = MyApplication.nwsSPCwebsitePrefix + "/exper/mesoanalysis/s"
        let radarImgUrl = baseUrl + sector + "/" + "rgnlrad" + "/" + "rgnlrad" + ".gif"
        let outlookImgUrl = baseUrl + sector + "/" + "otlk" + "/" + "otlk" + ".gif"
        let watwarnImgUrl = baseUrl + sector + "/" + "warns" + "/" + "warns" + ".gif"
        let topoImgUrl = baseUrl + sector + "/" + "topo" + "/" + "topo" + ".gif"
        if UtilitySPCMESO.imgSf.contains(product) && !showRadar {
            gifUrl = "_sf.gif"
        } else {
            gifUrl = ".gif"
        }
        let imgUrl = baseUrl + sector + "/" + product + "/" + product + gifUrl
        let bitmap = Bitmap(imgUrl)
        if showRadar && product != "1kmv" {
            if showTopo {layersRad.append(Drawable(Bitmap(topoImgUrl)))}
            let bitmapradar = Bitmap(radarImgUrl)
            layersRad.append(Drawable(bitmapradar))
            layersRad.append(Drawable(bitmap))
            if showOutlook {layersRad.append(Drawable(Bitmap(outlookImgUrl)))}
            if showWatwarn {layersRad.append(Drawable(Bitmap(watwarnImgUrl)))}
            return UtilityImg.layerDrawableToBitmap(layersRad)
        } else {
            if showTopo {layers.append(Drawable(Bitmap(topoImgUrl)))}
            layers.append(Drawable(bitmap))
            if showOutlook {layers.append(Drawable(Bitmap(outlookImgUrl)))}
            if showWatwarn {layers.append(Drawable(Bitmap(watwarnImgUrl)))}
            return UtilityImg.layerDrawableToBitmap(layers)
        }
    }

    static func getAnimation(_ sector: String, _ product: String, _ frameCount: Int) -> AnimationDrawable {
        var imgUrl = ""
        var bitmaps = [Bitmap]()
        let html = (MyApplication.nwsSPCwebsitePrefix
            + "/exper/mesoanalysis/new/archiveviewer.php?sector=19&parm=pmsl").getHtml()
        var timeList = html.parseColumn("dattim\\[[0-9]{1,2}\\].*?=.*?([0-9]{8})")
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
