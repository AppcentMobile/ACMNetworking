//
//  ACMProgressModel.swift
//
//
//  Created by Burak on 28.12.2023.
//

import Foundation

public struct ACMProgressModel {
    public var progress: Double
    public func formatted(with format: String = "%.2f") -> String {
        return String(format: format, progress)
    }

    public func formattedPercentage(with format: String = "%.f") -> String {
        let percentageProgress = progress * 100
        return String(format: format, percentageProgress)
    }
}
