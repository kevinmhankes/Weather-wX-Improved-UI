/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectNhcStormDetails {
    
    /*
     <nhc:center>30.8, -68.3<br>
     <nhc:type>Post-Tropical Cyclone<br>
     <nhc:name>Andrea<br>
     <nhc:wallet>AT1<br>
     <nhc:atcf>AL012019<br>
     <nhc:datetime>5:00 PM AST Tue May 21<br>
     <nhc:movement>ENE at 8 mph<br>
     <nhc:pressure>1009 mb<br>
     <nhc:wind>35 mph<br>
     <nhc:headline> ...ANDREA IS A REMNANT LOW... ...THIS IS THE LAST ADVISORY...<br>
     */

    var center = ""
    var type = ""
    var name = ""
    var wallet = ""
    var atcf = ""
    var dateTime = ""
    var movement = ""
    var pressure = ""
    var wind = ""
    var headline = ""

    init(_ data: String) {
        center = data.parse("<nhc:center>(.*?)</nhc:center>")
        type = data.parse("<nhc:type>(.*?)</nhc:type>")
        name = data.parse("<nhc:name>(.*?)</nhc:name>")
        wallet = data.parse("<nhc:wallet>(.*?)</nhc:wallet>")
        atcf = data.parse("<nhc:atcf>(.*?)</nhc:atcf>")
        dateTime = data.parse("<nhc:datetime>(.*?)</nhc:datetime>")
        movement = data.parse("<nhc:movement>(.*?)</nhc:movement>")
        pressure = data.parse("<nhc:pressure>(.*?)</nhc:pressure>")
        wind = data.parse("<nhc:wind>(.*?)</nhc:wind>")
        headline = data.parse("<nhc:headline>(.*?)</nhc:headline>")
    }
}
