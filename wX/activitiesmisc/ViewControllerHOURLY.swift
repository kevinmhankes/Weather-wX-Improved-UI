/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerHOURLY: UIwXViewController {

    var html = ""
    var playButton = ObjectToolbarIcon()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            (self.html, _) = UtilityHourly.getHourlyString(Location.getCurrentLocation())
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func textAction() {
        scrollView.scrollToTop()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(self.html, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, self.html)
    }

    private func displayContent() {

        // Declare a new SwiftySuncalc object
        //var suncalc: SwiftySuncalc! = SwiftySuncalc()
        // Get moon illumination times for today
        //var moonIllumination = suncalc.getMoonIllumination(date: Date())
        // Get the angle of the moon from the dictionary, `moonIllumination`
        //var moonAngle = moonIllumination["angle"]
        // Find out the times for today (e.g. sunset or sunrise)
        //var times = suncalc.getTimes(date: Date(), lat: Location.latLon.lat, lng: Location.latLon.lon);
        //var moonTimes = suncalc.getMoonTimes(date: Date(), lat: Location.latLon.lat, lng: Location.latLon.lon)
        //print(times["sunrise"])
        //print(times["sunset"])
        //print(moonTimes["set"])
        //print(moonTimes["rise"])

        /*
         ["sunriseEnd": 2019-06-20 10:03:10 +0000, "sunrise": 2019-06-20 09:59:44 +0000,
         "nightEnd": 2019-06-20 07:45:21 +0000, "sunset": 2019-06-21 01:16:13 +0000,
         "goldenHourEnd": 2019-06-20 10:42:22 +0000, "dawn": 2019-06-20 09:24:59 +0000,
         "goldenHour": 2019-06-21 00:33:35 +0000, "nauticalDusk": 2019-06-21 02:35:52 +0000,
         "nadir": 2019-06-20 05:37:59 +0000, "nauticalDawn": 2019-06-20 08:40:05 +0000,
         "night": 2019-06-21 03:30:37 +0000, "sunsetStart": 2019-06-21 01:12:47 +0000,
         "dusk": 2019-06-21 01:50:58 +0000, "solarNoon": 2019-06-20 17:37:59 +0000]
         ["set": Optional(2019-06-20 13:04:53 +0000), "rise": Optional(2019-06-21 03:57:33 +0000)]
 */

        let objTextView = ObjectTextView(
            self.stackView,
            self.html,
            FontSize.hourly.size,
            UITapGestureRecognizer(target: self, action: #selector(textAction))
        )
        scrollView.accessibilityElements = [objTextView.view]
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
