//
//  Palette.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.09.2023.
//

import Foundation
import UIKit

struct Palette {
    
    static var dynamicBackground =  UIColor.createColor(lightMode: UIColor.white,
                                                        darkMode: UIColor(red: 0.135,
                                                                          green: 0.139,
                                                                          blue: 0.178,
                                                                          alpha: 1.0))
    
    static var dynamicBars = UIColor.createColor(lightMode: UIColor.white,
                                                 darkMode: UIColor(red: 0.165,
                                                                   green: 0.169,
                                                                   blue: 0.208,
                                                                   alpha: 1.0))
    
    static var dynamicTextfield = UIColor.createColor(lightMode: UIColor.systemGray6,
                                                      darkMode: UIColor(red: 0.184,
                                                                        green: 0.192,
                                                                        blue: 0.235,
                                                                        alpha: 1.0))
    
}
