/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCanadaHourly {

    static func getString(_ location: Int) -> String {
        let url = MyApplication.canadaEcSitePrefix + "/forecast/hourly/"
            + MyApplication.locations[location].lat.split(":")[1].lowercased()
            + "-" + MyApplication.locations[location].lon.split(":")[0]
            + "_metric_e.html"
        let html = url.getHtml()
        let header = "Time   Temp   Summary   PrecipChance   Wind   Humindex"
        return header + parse(html)
    }

    static func getUrl(_ location: Int) -> String {
        return MyApplication.canadaEcSitePrefix + "/forecast/hourly/"
            + MyApplication.locations[location].lat.split(":")[1].lowercased()
            + "-"
            + MyApplication.locations[location].lon.split(":")[0]
            + "_metric_e.html"
    }

    static func parse(_ html: String) -> String {
        let htmlLocal = html.parse("<tbody>(.*?)</tbody>")
        let timeAl = htmlLocal.parseColumn("<tr>.*?<td.*?>(.*?)</td>.*?<td.*?>.*?</td>.*?<div"
            + " class=\"media.body\">.*?<p>.*?</p>.*?</div>.*?<td.*?>.*?</td>.*?"
            + "<abbr title=\".*?\">.*?</abbr>.*?<br />.*?<td.*?>.*?</td>.*?</tr>")
        let tempAl = htmlLocal.parseColumn("<tr>.*?<td.*?>.*?</td>.*?<td.*?>(.*?)</td>.*?<div"
            + " class=\"media.body\">.*?<p>.*?</p>.*?</div>.*?<td.*?>.*?</td>.*?"
            + "<abbr title=\".*?\">.*?</abbr>.*?<br />.*?<td.*?>.*?</td>.*?</tr>")
        let currCondAl = htmlLocal.parseColumn("<tr>.*?<td.*?>.*?</td>.*?<td.*?>.*?</td>.*?<div"
            + " class=\"media.body\">.*?<p>(.*?)</p>.*?</div>.*?<td.*?>.*?</td>.*?"
            + "<abbr title=\".*?\">.*?</abbr>.*?<br />.*?<td.*?>.*?</td>.*?</tr>")
        let popsAl = htmlLocal.parseColumn("<tr>.*?<td.*?>.*?</td>.*?<td.*?>.*?</td>.*?<div"
            + " class=\"media.body\">.*?<p>.*?</p>.*?</div>.*?<td.*?>(.*?)</td>.*?"
            + "<abbr title=\".*?\">.*?</abbr>.*?<br />.*?<td.*?>.*?</td>.*?</tr>")
        let windDirAl = htmlLocal.parseColumn("<tr>.*?<td.*?>.*?</td>.*?<td.*?>.*?</td>.*?<div"
            + " class=\"media.body\">.*?<p>.*?</p>.*?</div>.*?<td.*?>.*?</td>.*?"
            + "<abbr title=\".*?\">(.*?)</abbr>.*?<br />.*?<td.*?>.*?</td>.*?</tr>")
        let windSpeedAl = htmlLocal.parseColumn("<tr>.*?<td.*?>.*?</td>.*?<td.*?>.*?</td>.*?<div"
            + " class=\"media.body\">.*?<p>.*?</p>.*?</div>.*?<td.*?>.*?</td>.*?"
            + "<abbr title=\".*?\">.*?</abbr>(.*?)<br />.*?<td.*?>.*?</td>.*?</tr>")
        let humindexAl = htmlLocal.parseColumn("<tr>.*?<td.*?>.*?</td>.*?<td.*?>.*?</td>.*?<div"
            + " class=\"media.body\">.*?<p>.*?</p>.*?</div>.*?<td.*?>.*?</td>.*?"
            + "<abbr title=\".*?\">.*?</abbr>.*?<br />.*?<td.*?>(.*?)</td>.*?</tr>")
        let space = "   "
        var humindex = ""
        var string = ""
        timeAl.indices.forEach {
            humindex = humindexAl[$0].replaceAll("<abbr.*?>", "")
            humindex = humindex.replace("</abbr>", "")
            string += MyApplication.newline + timeAl[$0] + space + tempAl[$0] + space
                + currCondAl[$0] + space + popsAl[$0] + space + windDirAl[$0] + windSpeedAl[$0]
                + space + humindex
        }
        return string
    }
}
