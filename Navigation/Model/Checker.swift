//
//  Checker.swift
//  Navigation
//
//  Created by Ляпин Михаил on 15.04.2023.
//

import Foundation

class Checker {
  
    // MARK: Singleton
    static var shared = Checker()
    
    private init() {}
    
    //MARK: Private properties
    
    private let login: String = "furiousVader66"
    private let password: String = "isThisPasswordStrongEnough?"
    
    // MARK: - Private methods
    
    func check(login: String, password: String) -> Bool {
        return login == self.login && password == self.password
    }
    
}
