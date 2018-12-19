//
//  Extensions.swift
//  ChatAssistant
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: CGRect(x: 0, y: 0, width: frame.width, height: frame.height) , afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
