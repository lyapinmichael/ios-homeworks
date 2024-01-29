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
    
    static var dynamicSecondaryBackground = UIColor.createColor(lightMode: UIColor(red: 245/255,
                                                                                   green: 243/255,
                                                                                   blue: 238/255,
                                                                                   alpha: 1.0),
                                                                darkMode: UIColor(red: 0.165,
                                                                                  green: 0.169,
                                                                                  blue: 0.208,
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
    
    static var dynamicMonochromeButton = UIColor.createColor(lightMode: UIColor(red: 0.218,
                                                                                green: 0.206,
                                                                                blue: 0.200,
                                                                                alpha: 1.0),
                                                             darkMode: UIColor.white)
    
    static var dynamicTextInverted = UIColor.createColor(lightMode: UIColor.white,
                                                 darkMode: UIColor.black)
    
    static var dynamicText = UIColor.createColor(lightMode: UIColor.black,
                                                 darkMode: UIColor.white)
    
    static var accentOrange = UIColor.createColor(lightMode: UIColor(red: 256/255,
                                                                     green: 151/255,
                                                                     blue: 7/255,
                                                                     alpha: 1),
                                                  darkMode:UIColor(red: 256/255,
                                                                   green: 151/255,
                                                                   blue: 7/255,
                                                                   alpha: 1))
    
    static var accentBlue = UIColor(red: 8/255,
                                      green: 99/255,
                                      blue: 235/255,
                                      alpha: 1)
    
    private init() {} 
}
