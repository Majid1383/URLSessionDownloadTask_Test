//
//  GlobalFunctions.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 18/11/24.
//

import Foundation
import UIKit


class GlobalFunctions {
    
    //Adding a Colours.
    static func randomNeonColor() -> UIColor {
        let randomColorComponent = { CGFloat.random(in: 0.5...1.0) }
        let red = randomColorComponent()
        let green = randomColorComponent()
        let blue = randomColorComponent()
        
        let components = [red, green, blue].shuffled()
        return UIColor(red: components[0], green: components[1], blue: components[2], alpha: 1.0)
    }
    
}
