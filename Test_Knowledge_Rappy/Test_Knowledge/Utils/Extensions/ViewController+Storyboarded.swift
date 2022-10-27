//
//  ViewController+Storyboard.swift
//  FaceSampleApp
//
//  Created by Marek Swiecznik on 20/05/2019.
//  Copyright © 2019 IDEMIA. All rights reserved.
//

import UIKit

/// A protocol used for instantiating a view controller from a storyboard.
protocol Storyboarded {
    static func instantiate(fromStoryboardNamed: String) -> Self
}

/// An extension with default implementation used for instantiating a view controller from a storyboard.
extension Storyboarded where Self: UIViewController {
    static func instantiate(fromStoryboardNamed storyboardName: String = "Main") -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension Storyboarded where Self: UITabBarController {
    static func instantiate(fromStoryboardNamed storyboardName: String = "Main") -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension Storyboarded where Self: UINavigationController {
    static func instantiate(fromStoryboardNamed storyboardName: String = "Main") -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}


