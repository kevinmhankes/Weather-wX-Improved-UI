/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerPLAYLIST: UIwXViewController {

    var playlistItems = [String]()
    var addButton = ObjectToolbarIcon()
    var wfotextButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    let textPreviewLength = 150
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton = ObjectToolbarIcon(self, "ic_play_arrow_24dp", #selector(playClicked))
        let downloadButton = ObjectToolbarIcon(self, "ic_get_app_24dp", #selector(downloadClicked))
        addButton = ObjectToolbarIcon(self, "ic_add_box_24dp", #selector(addClicked))
        wfotextButton = ObjectToolbarIcon(self, "ic_info_outline_24dp", #selector(wfotextClicked))
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            wfotextButton,
                                            addButton,
                                            playButton,
                                            downloadButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        deSerializeSettings()
        updateView()
    }

    @objc override func doneClicked() {
        serializeSettings()
        super.doneClicked()
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let alert = ObjectPopUp(self, "", addButton)
        alert.addAction(UIAlertAction("Play", {_ in self.playProduct(selection: sender.data)}))
        alert.addAction(UIAlertAction("View Text", {_ in self.viewProduct(selection: sender.data)}))
        if sender.data != 0 {
            alert.addAction(UIAlertAction("Move Up", {_ in self.move(sender.data, .up)}))
        }
        if sender.data != (playlistItems.count - 1) {
            alert.addAction(UIAlertAction("Move Down", {_ in self.move(sender.data, .down)}))
        }
        alert.addAction(UIAlertAction("Delete", {_ in self.delete(selection: sender.data)}))
        alert.finish()
    }

    func playProduct(selection: Int) {
        UtilityActions.stopAudio(synth, playButton)
        playlistItems.enumerated().forEach {
            if $0 >= selection {
                UtilityActions.playClickedNewItem(preferences.getString("PLAYLIST_" + $1, ""), synth, playButton)
            }
        }
    }

    func viewProduct(selection: Int) {
        ActVars.TEXTVIEWText = preferences.getString("PLAYLIST_" + playlistItems[selection], "")
        self.goToVC("textviewer")
    }

    func move(_ from: Int, _ to: MotionType) {
        var delta = 1
        if to == .up {
            delta = -1
        }
        let tmp = playlistItems[from + delta]
        playlistItems[from + delta] = playlistItems[from]
        playlistItems[from] = tmp
        updateView()
    }

    func delete(selection: Int) {
        editor.removeObject("PLAYLIST_" + playlistItems[selection])
        editor.removeObject("PLAYLIST_" + playlistItems[selection] + "_TIME")
        playlistItems.remove(at: selection)
        updateView()
    }

    func serializeSettings() {
        playlistItems = playlistItems.filter { $0 != "" }
        let token = TextUtils.join(":", playlistItems)
        MyApplication.playlistStr = token
        editor.putString("PLAYLIST", token)
    }

    func deSerializeSettings() {
        playlistItems = TextUtils.split(preferences.getString("PLAYLIST", "") + ":", ":")
        playlistItems = playlistItems.filter { $0 != "" }
    }

    func updateView() {
        self.stackView.subviews.forEach {$0.removeFromSuperview()}
        playlistItems.enumerated().forEach {
            let txtObject = ObjectTextView(self.stackView,
                                           $1 + " " + preferences.getString("PLAYLIST_" + $1 + "_TIME", ""))
            txtObject.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
            txtObject.addGestureRecognizer(
                UITapGestureRecognizerWithData(
                    data: $0,
                    target: self,
                    action: #selector(self.buttonPressed(sender:))
                )
            )
        }
    }

    @objc func playClicked() {
        playlistItems.forEach {
            UtilityActions.playClicked(preferences.getString("PLAYLIST_" + $0, ""), synth, playButton)
        }
    }

    @objc func downloadClicked() {
        serializeSettings()
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityPlayList.downloadAll()
            DispatchQueue.main.async {self.updateView()}
        }
    }

    @objc func addClicked() {
        let alert = ObjectPopUp(self, "Product Selection", addButton)
        GlobalArrays.nwsTextProducts.forEach {
            var imageTypeCode = $0.split(":")
            alert.addAction(UIAlertAction(title: $0,
                                          style: .default,
                                          handler: {_ in self.addProduct(imageTypeCode[0])}))
        }
        alert.finish()
    }

    func addProduct(_ product: String) {
        playlistItems.append(product.uppercased())
        updateView()
    }

    @objc func wfotextClicked() {
        let alert = ObjectPopUp(self, "Product Selection", wfotextButton)
        GlobalArrays.wfos.forEach {
            var imageTypeCode = $0.split(":")
            alert.addAction(UIAlertAction($0, {_ in self.addWfoProduct(imageTypeCode[0])}))
        }
        alert.finish()
    }

    func addWfoProduct(_ product: String) {
        playlistItems.append("AFD" + product.uppercased())
        updateView()
    }
}
