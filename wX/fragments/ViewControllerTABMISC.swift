/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerTABMISC: ViewControllerTABPARENT {

    var fab: ObjectFab!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fab = ObjectFab(self, #selector(radarClicked(sender:)))
        self.view.addSubview(fab.view)
        objTileMatrix = ObjectImageTileMatrix(self, stackView, .misc)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //fab.view.recalculateItemsOrigin()
        //fab.view.setNeedsDisplay()
        fab.view.layoutSubviews()
        fab.view.setNeedsDisplay()
        fab.view.recalculateItemsOrigin()
        print(fab.view.paddingX)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        fab.view.layoutSubviews()
        //fab.view.setNeedsDisplay()
    }
    
    @objc func radarClicked(sender: UITapGestureRecognizer) {
        UtilityActions.radarClicked(self)
    }
}
