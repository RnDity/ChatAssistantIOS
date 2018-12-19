//
//  UIView+AddSubviews.swift
//  BoomerunView
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    public func add(_ subviews: UIView...) -> UIView {
        subviews.forEach{
            self.addSubview($0)
        }
        
        return self
    }
    
    public func test() {
        let container = UIView()
        let nestedContainer = UIView()
        let button = UIButton()
        let label = UILabel()
        let otherNestedContainer = UIView()
        let otherButton = UIButton()
        
        // version without add function
        container.addSubview(button)
        container.addSubview(nestedContainer)
        nestedContainer.addSubview(otherNestedContainer)
        nestedContainer.addSubview(otherButton)
        otherNestedContainer.addSubview(label)
        otherNestedContainer.addSubview(button)
        
        // version with add function
        container.add (
            button,
            nestedContainer.add (
                otherNestedContainer.add (
                    label,
                    button
                ),
                otherButton
            )
        )
    }
}
