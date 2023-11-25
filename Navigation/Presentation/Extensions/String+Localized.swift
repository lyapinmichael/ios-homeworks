//
//  String+Localized.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.09.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
