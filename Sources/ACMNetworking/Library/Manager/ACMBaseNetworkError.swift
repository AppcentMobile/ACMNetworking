//
//  ACMBaseNetworkError.swift
//

struct ACMBaseNetworkError: Error {
    var message: String?
    var log: String?
    var endpoint: ACMBaseEndpoint?
}
