/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
    var fabRight: ObjectFab?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        playButton = ObjectToolbarIcon(self, "ic_play_arrow_24dp", #selector(playClicked))
        let downloadButton = ObjectToolbarIcon(self, "ic_get_app_24dp", #selector(downloadClicked))
        addButton = ObjectToolbarIcon(self, "ic_add_box_24dp", #selector(addClicked))
        wfotextButton = ObjectToolbarIcon(self, "ic_info_outline_24dp", #selector(wfotextClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                flexBarButton,
                wfotextButton,
                addButton,
                playButton,
                downloadButton
            ]
        ).items
        stackView.widthAnchor.constraint(
            equalToConstant: self.view.frame.width - UIPreferences.sideSpacing
        ).isActive = true
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        deSerializeSettings()
        fabRight = ObjectFab(self, #selector(playClicked), imageString: "ic_play_arrow_24dp")
        self.view.addSubview(fabRight!.view)
        updateView()
        downloadClicked()
    }

    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
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
                UtilityActions.playClickedNewItem(Utility.readPref("PLAYLIST_" + $1, ""), synth, playButton)
            }
        }
    }

    func viewProduct(selection: Int) {
        ActVars.textViewText = Utility.readPref("PLAYLIST_" + playlistItems[selection], "")
        ActVars.textViewProduct = playlistItems[selection]
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
        Utility.writePref("PLAYLIST", token)
    }

    func deSerializeSettings() {
        playlistItems = TextUtils.split(Utility.readPref("PLAYLIST", "") + ":", ":")
        playlistItems = playlistItems.filter { $0 != "" }
    }

    func updateView() {
        self.stackView.subviews.forEach {$0.removeFromSuperview()}
        playlistItems.enumerated().forEach {
            let productText = Utility.readPref("PLAYLIST_" + $1, "")
            let topLine = " "
                + Utility.readPref("PLAYLIST_" + $1 + "_TIME", "")
                + " (size: " + String(productText.count) + ")"
            _ = ObjectCardPlayListItem(
                self.stackView,
                $1,
                topLine,
                productText.truncate(200),
                UITapGestureRecognizerWithData($0, self, #selector(self.buttonPressed(sender:)))
            )
        }
    }

    @objc func playClicked() {
        playlistItems.forEach {
            UtilityActions.playClicked(Utility.readPref("PLAYLIST_" + $0, ""), synth, playButton)
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
        _ = ObjectPopUp(self, "Product Selection", addButton, GlobalArrays.nwsTextProducts, self.addProduct(_:))
    }

    func addProduct(_ product: String) {
        playlistItems.append(product.uppercased())
        updateView()
    }

    @objc func wfotextClicked() {
        _ = ObjectPopUp(self, "Product Selection", wfotextButton, GlobalArrays.wfos, self.addWfoProduct(_:))
    }

    func addWfoProduct(_ product: String) {
        playlistItems.append("AFD" + product.uppercased())
        updateView()
    }

    private func displayContent() {
        stackView.widthAnchor.constraint(
            equalToConstant: self.view.frame.width - UIPreferences.sideSpacing
        ).isActive = true
        updateView()
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
