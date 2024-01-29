//
//  Observable.swift
//  Navigation
//
//  Created by Ляпин Михаил on 21.01.2024.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
            
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    private var listener: ((T)->Void)?
    
    func bind(listener: ((T)->Void)?) {
        self.listener = listener
        self.listener?(value)
    }
    
}

