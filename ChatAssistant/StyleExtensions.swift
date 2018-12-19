//
//  StyleExtensions.swift
//  BoomerunView
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @nonobjc class var black: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var steel: UIColor {
        return UIColor(red: 138.0 / 255.0, green: 138.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var silver: UIColor {
        return UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGrey: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var white: UIColor {
        return UIColor(white: 249.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var royalBlue: UIColor {
        return UIColor(red: 16.0 / 255.0, green: 6.0 / 255.0, blue: 159.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var warmPink: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 96.0 / 255.0, blue: 126.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var brownishGrey: UIColor {
        return UIColor(white: 102.0 / 255.0, alpha: 1.0)
    }
}

extension UIFont {
    
    class var topBarTitle: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    class var listTitle: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    class var divider: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }
    
    class var headlineCenter: UIFont {
        return UIFont.systemFont(ofSize: 24.0, weight: .regular)
    }
    
    class var subheading: UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: .light)
    }
    
    class var caption: UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }
    
    class var buttonBottom: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    class var actionButton: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    class var option: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    class var tapBarLabel: UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: .medium)
    }
    
    class var buttonBottomBig: UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: .semibold)
    }
    
    class var topBarTitleWhite: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    class var actionButtonWhite: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
}
