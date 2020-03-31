//
//  Int+Extension.swift
//  Task1
//
//  Created by Konstantin Mishukov on 31.03.2020.
//  Copyright © 2020 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension Int {
    /// ---
    ///     var n: Int = 5
    ///     n = n.safeString
    ///     print(n)  // "05"
    /// ---
    var safeString: String {
        return self >= 10 ? "\(self)" : "0\(self)"
    }
}
