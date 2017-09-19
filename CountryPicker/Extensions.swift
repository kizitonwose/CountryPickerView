//
//  Extensions.swift
//  CountryPicker
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import Foundation

extension UIWindow {
    var topViewController: UIViewController? {
        guard var top = rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}
