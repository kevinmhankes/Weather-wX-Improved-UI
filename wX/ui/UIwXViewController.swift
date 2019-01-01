/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UIwXViewController: UIViewController {

    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let toolbar = ObjectToolbar()
    var doneButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        UtilityActions.ttsPrep()
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        toolbar.setConfig()
        doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
    }

    @objc func doneClicked() {
        self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }
}
