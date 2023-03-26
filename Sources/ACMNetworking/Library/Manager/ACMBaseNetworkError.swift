//
//  ACMBaseNetworkError.swift
//

struct ACMBaseNetworkError: Error {
    /// Message holds the error description
    var message: String?
    /// Log holds the localization description
    var log: String?
    /// Endpoint holds the current endpoint that calls
    var endpoint: ACMBaseEndpoint?
}
