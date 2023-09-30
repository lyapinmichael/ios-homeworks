//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.09.2023.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizatoinService {
    
    enum BiometryType {
        case none
        case touchID
        case faceID
        
        var imageSystemName: String {
            switch self {
            case .none:
                return  "questionmark.diamond"
            case .faceID:
                return "faceid"
            case .touchID:
                return "touchid"
            }
        }
    }
    
    var biometryType: BiometryType {
        get {
            switch context.biometryType {
            case .none:
                return .none
            case .faceID:
                return .faceID
            case .touchID:
                return .touchID
            @unknown default:
                print("Error occured while gathering device biometry type")
                return .none
            }
        }
    }
    
    private let context = LAContext()
    private var canEvaluatePolicy = false
    private var policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
    init() {
        
        var error: NSError? = nil
        canEvaluatePolicy = context.canEvaluatePolicy(policy, error: &error)
        
        if error != nil {
            print("Authentication failed",error!)
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        
        guard canEvaluatePolicy else { return }
        
        context.evaluatePolicy(policy, localizedReason: "LAPolicy".localized, reply: { success, error in
            
            if success {
                authorizationFinished(true)
            } else {
                print("Error occured:\t" + error.debugDescription)
            }
        })
        
    }
    
}
