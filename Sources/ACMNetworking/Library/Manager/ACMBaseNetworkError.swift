//
//  ACMBaseNetworkError.swift
//

public struct ACMBaseNetworkError: Error {
    /// Message holds the error description
    public var message: String?
    /// Log holds the localization description
    public var log: String?
    /// Endpoint holds the current endpoint that calls
    public var endpoint: ACMBaseEndpoint?
    /// Status code
    public var statusCode: Int?
}
