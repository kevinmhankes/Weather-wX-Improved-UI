//
//  TabBarControllerSwipeExtension.swift
//  SwipeTabBar-Swift
//
//  Created by Cezar Carvalho Pereira on 23/1/15.
//  Copyright (c) 2015 Wavebits. All rights reserved.
//

/*
 
 https://github.com/cezarcp/swipe-tab-bar/blob/master/LICENSE
 
 Copyright (c) 2016 Cezar Pereira, http://cezar.org
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

extension UITabBarController {

    func setupSwipeGestureRecognizers(allowCyclingThoughTabs cycleThroughTabs: Bool = false) {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: cycleThroughTabs ? #selector(handleSwipeLeftAllowingCyclingThroughTabs) : #selector(handleSwipeLeft)
        )
        swipeLeftGestureRecognizer.direction = .left
        tabBar.addGestureRecognizer(swipeLeftGestureRecognizer)
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: cycleThroughTabs
                ? #selector(handleSwipeRightAllowingCyclingThroughTabs)
                : #selector(handleSwipeRight)
        )
        swipeRightGestureRecognizer.direction = .right
        tabBar.addGestureRecognizer(swipeRightGestureRecognizer)
    }

    @objc private func handleSwipeLeft(swipe: UISwipeGestureRecognizer) {
        selectedIndex -= 1
    }

    @objc private func handleSwipeRight(swipe: UISwipeGestureRecognizer) {
        selectedIndex += 1
    }

    @objc private func handleSwipeLeftAllowingCyclingThroughTabs(swipe: UISwipeGestureRecognizer) {
        let maxIndex = (viewControllers?.count ?? 0)
        let nextIndex = selectedIndex - 1
        selectedIndex = nextIndex >= 0 ? nextIndex : maxIndex - 1
    }

    @objc private func handleSwipeRightAllowingCyclingThroughTabs(swipe: UISwipeGestureRecognizer) {
        let maxIndex = (viewControllers?.count ?? 0)
        let nextIndex = selectedIndex + 1
        selectedIndex = nextIndex < maxIndex ? nextIndex : 0
    }
}
