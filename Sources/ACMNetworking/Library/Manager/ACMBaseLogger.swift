//
//  ACMBaseLogger.swift
//

import Foundation
import os.log

final class ACMBaseLogger {
    var config: ACMPlistModel?

    init(config: ACMPlistModel? = nil) {
        self.config = config
    }

    /// is BaseLoggerging enable
    var isEnabled: Bool {
        return config?.isLogEnabled ?? false
    }

    /// BaseLogger for success. Will add ✅ emoji to see better
    ///
    /// - Parameter message: BaseLoggerging message
    func info(_ message: String?) {
        guard isEnabled else { return }
        debug(type: "✅", message: message ?? "")
    }

    /// BaseLogger for warning. Will add ⚠️ emoji to see better
    ///
    /// - Parameter message: BaseLoggerging message
    func warning(_ message: String?) {
        guard isEnabled else { return }
        debug(type: "⚠️", message: message ?? "")
    }

    /// BaseLogger for error. Will add ❌ emoji to see better
    ///
    /// - Parameter message: BaseLoggerging message
    func error(_ message: String?) {
        guard isEnabled else { return }
        debug(type: "❌", message: message ?? "")
    }

    private func debug(type: Any?, message: String) {
        guard isEnabled else { return }
        DispatchQueue.main.async {
            os_log("%@", type: .debug, "\(type ?? "") -> \(message)")
        }
    }
}
