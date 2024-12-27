//
//  Decimal+Extension.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/26/24.
//

import Foundation

extension Decimal {
    var convert: String {
        self.formatted(.number.precision(.fractionLength(1)))
    }
}
