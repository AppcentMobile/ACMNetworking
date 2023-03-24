//
//  ACMNetworking+Extensions.swift
//

import Foundation

extension ACMNetworking {
    func baseRequest(to endpoint: ACMBaseEndpoint) -> URLRequest? {
        guard let urlRequest = endpoint.urlRequest else {
            ACMBaseLogger.error(ACMNetworkConstants.urlRequestErrorMessage)
            return nil
        }

        let info = ACMStringUtils.shared.merge(list: [
            ACMNetworkConstants.httpRequestType,
            endpoint.method.rawValue,
        ])
        ACMBaseLogger.info(info)

        if let url = endpoint.url {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpURLMessage,
                "\(url)",
            ])
            ACMBaseLogger.info(info)
        }

        if let authHeader = endpoint.authHeader, authHeader.count > 0 {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpAuthHeadersMessage,
                "\(authHeader)",
            ])
            ACMBaseLogger.info(info)
        }

        if let headers = endpoint.headers, headers.count > 0 {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpHeadersMessage,
                "\(headers)",
            ])
            ACMBaseLogger.info(info)
        }

        if let queryItems = endpoint.queryItems, queryItems.count > 0 {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpQueryItemsMessage,
                "\(queryItems)",
            ])
            ACMBaseLogger.info(info)
        }

        if let data = urlRequest.httpBody {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                String(data: data, encoding: .utf8) ?? "",
            ])
            ACMBaseLogger.info(info)
        }

        return urlRequest
    }
}
