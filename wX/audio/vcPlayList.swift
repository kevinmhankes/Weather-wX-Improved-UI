/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcPlayList: UIwXViewController, AVSpeechSynthesizerDelegate {
    
    private var playlistItems = [String]()
    private var addNationalProductButton = ObjectToolbarIcon()
    private var wfoTextButton = ObjectToolbarIcon()
    private let textPreviewLength = 400
    private var synth = AVSpeechSynthesizer()
    private var fab: ObjectFab?
    
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
        addNationalProductButton = ObjectToolbarIcon(self, .plus, #selector(addNationalProductClicked))
        wfoTextButton = ObjectToolbarIcon(self, .wfo, #selector(wfotextClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                wfoTextButton,
                addNationalProductButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        deSerializeSettings()
        fab = ObjectFab(self, #selector(playClicked), iconType: .play)
        //self.view.addSubview(fab!.view)
        updateView()
        refreshData()
    }
    
    @objc func willEnterForeground() {
        refreshData()
    }
    
    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        UtilityAudio.resetAudio(&synth, fab!)
        serializeSettings()
        super.doneClicked()
    }
    
    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let alert = ObjectPopUp(self, playlistItems[sender.data], addNationalProductButton)
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
        UtilityAudio.resetAudio(&synth, fab!)
        playlistItems.enumerated().forEach { index, item in
            if index >= selection {
                UtilityAudio.playClickedNewItem(Utility.readPref("PLAYLIST_" + item, ""), synth, fab!)
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
        UtilityAudio.playClicked(textToSpeak, synth, fab!)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityAudio.resetAudio(&self.synth, self.fab!)
        }
    }
    
    @objc func refreshData() {
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
    
    @objc func addNationalProductClicked() {
        _ = ObjectPopUp(self, "Product Selection", addNationalProductButton, UtilityWpcText.labels, self.addNationalProduct(_:))
    }
    
    func addNationalProduct(_ index: Int) {
        let product = UtilityWpcText.labelsWithCodes[index].split(":")[0].uppercased()
        downloadAndAddProduct(product, self.addNationalProductButton)
    }
    
    @objc func wfotextClicked() {
        _ = ObjectPopUp(self, "Product Selection", wfoTextButton, GlobalArrays.wfos, self.addWfoProduct(_:))
    }
    
    func addWfoProduct(_ product: String) {
        let product = "AFD" + product.uppercased()
        downloadAndAddProduct(product, self.wfoTextButton)
    }
    
    func downloadAndAddProduct(_ product: String, _ button: ObjectToolbarIcon) {
        DispatchQueue.global(qos: .userInitiated).async {
            let text = UtilityDownload.getTextProduct(product)
            DispatchQueue.main.async {
                let productAdded = UtilityPlayList.add(product, text, self, button, showStatus: false)
                if productAdded {
                    self.playlistItems.append(product)
                    self.updateView()
                    self.serializeSettings()
                }
            }
        }
    }
    
    private func displayContent() {
        updateView()
    }
}
