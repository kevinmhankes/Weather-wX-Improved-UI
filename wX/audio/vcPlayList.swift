/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcPlayList: UIwXViewController, AVSpeechSynthesizerDelegate {
    
    private var playlistItems = [String]()
    private var addButton = ObjectToolbarIcon()
    private var wfoTextButton = ObjectToolbarIcon()
    private var playButton = ObjectToolbarIcon()
    private let textPreviewLength = 400
    private var synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        synth.delegate = self
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        let downloadButton = ObjectToolbarIcon(self, .download, #selector(downloadClicked))
        addButton = ObjectToolbarIcon(self, .plus, #selector(addClicked))
        wfoTextButton = ObjectToolbarIcon(self, .wfo, #selector(wfotextClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                wfoTextButton,
                addButton,
                playButton,
                downloadButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        deSerializeSettings()
        let fabRight = ObjectFab(self, #selector(playClicked), imageString: "ic_play_arrow_24dp")
        self.view.addSubview(fabRight.view)
        updateView()
        downloadClicked()
    }
    
    @objc func willEnterForeground() {
        downloadClicked()
    }
    
    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        UtilityActions.resetAudio(&synth, playButton)
        serializeSettings()
        super.doneClicked()
    }
    
    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let alert = ObjectPopUp(self, playlistItems[sender.data], addButton)
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
        playlistItems.enumerated().forEach { index, item in
            if index >= selection {
                UtilityActions.playClickedNewItem(Utility.readPref("PLAYLIST_" + item, ""), synth, playButton)
            }
        }
    }
    
    func viewProduct(selection: Int) {
        let vc = vcTextViewer()
        vc.textViewText = Utility.readPref("PLAYLIST_" + playlistItems[selection], "")
        vc.textViewProduct = playlistItems[selection]
        self.goToVC(vc)
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
        GlobalVariables.editor.removeObject("PLAYLIST_" + playlistItems[selection])
        GlobalVariables.editor.removeObject("PLAYLIST_" + playlistItems[selection] + "_TIME")
        playlistItems.remove(at: selection)
        updateView()
    }
    
    func serializeSettings() {
        playlistItems = playlistItems.filter { $0 != "" }
        let token = TextUtils.join(":", playlistItems)
        MyApplication.playlistStr = token
        Utility.writePref("PLAYLIST", token)
    }
    
    func deSerializeSettings() {
        playlistItems = TextUtils.split(Utility.readPref("PLAYLIST", "") + ":", ":")
        playlistItems = playlistItems.filter { $0 != "" }
    }
    
    func updateView() {
        self.stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        playlistItems.enumerated().forEach {
            let productText = Utility.readPref("PLAYLIST_" + $1, "")
            let topLine = " " + Utility.readPref("PLAYLIST_" + $1 + "_TIME", "") + " (size: " + String(productText.count) + ")"
            _ = ObjectCardPlayListItem(
                self.scrollView,
                self.stackView,
                $1,
                topLine,
                productText.truncate(textPreviewLength),
                UITapGestureRecognizerWithData($0, self, #selector(self.buttonPressed(sender:)))
            )
        }
    }
    
    @objc func playClicked() {
        var textToSpeak = ""
        playlistItems.forEach {
            textToSpeak += Utility.readPref("PLAYLIST_" + $0, "")
        }
        UtilityActions.playClicked(textToSpeak, synth, playButton)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityActions.resetAudio(&self.synth, self.playButton)
        }
    }
    
    @objc func downloadClicked() {
        serializeSettings()
        playlistItems.forEach {
            let product = $0
            DispatchQueue.global(qos: .userInitiated).async {
                UtilityPlayList.download(product)
                DispatchQueue.main.async {
                    self.updateView()
                }
            }
        }
    }
    
    @objc func addClicked() {
        _ = ObjectPopUp(self, "Product Selection", addButton, UtilityWpcText.labels, self.addProduct(_:))
    }
    
    // FIXME use method from utilityPlaylist
    func addProduct(_ index: Int) {
        let product = UtilityWpcText.labelsWithCodes[index].split(":")[0].uppercased()
        if !playlistItems.contains(product) {
            playlistItems.append(product)
        } else {
            _ = ObjectToast(product + " already in playlist.", self, addButton)
        }
        updateView()
    }
    
    @objc func wfotextClicked() {
        _ = ObjectPopUp(self, "Product Selection", wfoTextButton, GlobalArrays.wfos, self.addWfoProduct(_:))
    }
    
    // FIXME use method from utilityPlaylist
    func addWfoProduct(_ product: String) {
        let product = "AFD" + product.uppercased()
        if !playlistItems.contains(product) {
            playlistItems.append(product)
        } else {
            _ = ObjectToast(product + " already in playlist.", self, addButton)
        }
        updateView()
    }
    
    private func displayContent() {
        updateView()
    }
}
