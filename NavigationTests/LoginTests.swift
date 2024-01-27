//
//  LoginTests.swift
//  NavigationTests
//
//  Created by Ляпин Михаил on 21.09.2023.
//

import Foundation
import XCTest
@testable import Navigation

import FirebaseAuth


final class LoginInspectorTests: XCTestCase {
    
    func testCheckCredentialsWithResult() {
        let loginInspector = LoginInspectorMock()
        
        loginInspector.fakeLoginResult = .success(("email", "username"))
        loginInspector.logIn(email: "email", password: "password") { _ in
    
            XCTAssertEqual(loginInspector.state, .didLogin(true))
            
        }
    }
    
    func testCheckCredentioalsWithError() {
        let loginInspector = LoginInspectorMock()
        
        loginInspector.fakeLoginResult = .failure(.authResultIsNil)
        loginInspector.logIn(email: "email", password: "password") { _ in
            
            XCTAssertEqual(loginInspector.state, .didLogin(false))
            
        }
    }
    
    func testSignUpWithResult() {
        
        let loginInspector = LoginInspectorMock()
        
        loginInspector.fakeSignUpResult = .success("userEmail")
        loginInspector.signUp(email: "useremail", password: "userpassword", fullName: "username") { _ in
            
            XCTAssertEqual(loginInspector.state, .didSignUp(true))
            
        }
        
    }
    
    func testSignUpWithError() {
        
        let loginInspector = LoginInspectorMock()
        
        loginInspector.fakeSignUpResult = .failure(.failedToSignUp)
        loginInspector.signUp(email: "useremail", password: "userpassword", fullName: "username") { _ in
            
            XCTAssertEqual(loginInspector.state, .didSignUp(false))
            
        }
    }
    
}

fileprivate final class LoginInspectorMock: AuthenticationProtocol {
    
    var state: LoginInspectorState = .didLogin(false)
   
    var fakeLoginResult: Result<(String?, String?), LoginInspectorErrors>!
    var fakeSignUpResult: Result<String?, LoginInspectorErrors>!
    
    func logIn(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void)) {
        
        switch fakeLoginResult {
        case .success:
            state = .didLogin(true)
        case .failure:
            state = .didLogin(false)
        case .none:
            break
        }
        
        completion(fakeLoginResult)
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String?, LoginInspectorErrors>) -> Void)){
        
        switch fakeSignUpResult {
        case .success:
            state = .didSignUp(true)
        case .failure:
            state = .didSignUp(false)
        case .none:
            break
        }
        
        completion(fakeSignUpResult)
        
    }
    
    func signOut() {
        print("Not yet implemented")
    }
    
    
    
    
}
