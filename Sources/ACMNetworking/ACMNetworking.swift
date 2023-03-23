//
//  ACMNetworking.swift
//

import Foundation

public struct ACMNetworking {
    public var errorMessage = "An error occurred."
    public var responseInfoMessage = "RESPONSE:"
    public var responseNullMessage = "Response null"
    public var dataNullMessage = "Data null"
    public var dataParseSuccessMessage = "Data parsed successfully"
    public var dataParseErrorMessage = "Data parsing error : %@"
    public var urlRequestErrorMessage = "URL Request Error"
    public var httpStatusError = "HTTP Status error"
    public var httpURLMessage = "HTTP URL:"
    public var httpAuthHeadersMessage = "HTTP AUTH HEADERS:"
    public var httpHeadersMessage = "HTTP HEADERS:"
    public var httpQueryItemsMessage = "HTTP QUERYITEMS:"
    public var httpBodyMessage = "HTTP BODY:"
    public var httpRequestType = "HTTP Request TYPE:"

    public init() {}

    private func baseRequest(to endpoint: ACMBaseEndpoint) -> URLRequest? {
        guard let urlRequest = endpoint.urlRequest else {
            ACMBaseLogger.error(urlRequestErrorMessage)
            return nil
        }

        let info = ACMStringUtils.shared.merge(list: [
            httpRequestType,
            endpoint.method.rawValue,
        ])
        ACMBaseLogger.info(info)

        if let url = endpoint.url {
            let info = ACMStringUtils.shared.merge(list: [
                httpURLMessage,
                "\(url)",
            ])
            ACMBaseLogger.info(info)
        }

        if let authHeader = endpoint.authHeader, authHeader.count > 0 {
            let info = ACMStringUtils.shared.merge(list: [
                httpAuthHeadersMessage,
                "\(authHeader)",
            ])
            ACMBaseLogger.info(info)
        }

        if let headers = endpoint.headers, headers.count > 0 {
            let info = ACMStringUtils.shared.merge(list: [
                httpHeadersMessage,
                "\(headers)",
            ])
            ACMBaseLogger.info(info)
        }

        if let queryItems = endpoint.queryItems, queryItems.count > 0 {
            let info = ACMStringUtils.shared.merge(list: [
                httpQueryItemsMessage,
                "\(queryItems)",
            ])
            ACMBaseLogger.info(info)
        }

        if let data = urlRequest.httpBody {
            let info = ACMStringUtils.shared.merge(list: [
                httpBodyMessage,
                String(data: data, encoding: .utf8) ?? "",
            ])
            ACMBaseLogger.info(info)
        }

        return urlRequest
    }

    public func request<T: Decodable>(to endpoint: ACMBaseEndpoint,
                                      onSuccess: ACMGenericCallbacks.ResponseCallback<T>,
                                      onError: ACMGenericCallbacks.ErrorCallback) {
        guard let urlRequest = baseRequest(to: endpoint) else {
            ACMBaseLogger.error(urlRequestErrorMessage)
            return
        }

        let dataTask = endpoint.session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    error?.localizedDescription ?? "",
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: self.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
                return
            }
            guard response != nil else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.responseNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: self.errorMessage, log: self.responseNullMessage, endpoint: endpoint))
                return
            }
            guard let data = data else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint))
                return
            }

            if error?.isConnectivityError ?? false {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.httpStatusError,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: self.errorMessage, log: self.httpStatusError, endpoint: endpoint))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)

                let info = ACMStringUtils.shared.merge(list: [
                    self.responseInfoMessage,
                    String(data: data, encoding: .utf8) ?? "",
                ])
                ACMBaseLogger.info(info)
                onSuccess?(responseObject)
            } catch let DecodingError.dataCorrupted(context) {
                let message = ACMStringUtils.shared.merge(list: [
                    context.debugDescription,
                ])
                ACMBaseLogger.error(message)
            } catch let DecodingError.keyNotFound(key, context) {
                let message = ACMStringUtils.shared.merge(list: [
                    "Key \(key) not found: \(context.debugDescription)",
                    "codingPath: \(context.codingPath)",
                ])
                ACMBaseLogger.error(message)
            } catch let DecodingError.valueNotFound(value, context) {
                let message = ACMStringUtils.shared.merge(list: [
                    "Value \(value) not found: \(context.debugDescription)",
                    "codingPath: \(context.codingPath)",
                ])
                ACMBaseLogger.error(message)
            } catch let DecodingError.typeMismatch(type, context) {
                let message = ACMStringUtils.shared.merge(list: [
                    "Type \(type) mismatch: \(context.debugDescription)",
                    "codingPath: \(context.codingPath)",
                ])
                ACMBaseLogger.error(message)
            } catch let e {
                let errorMessage = String(format: self.dataParseErrorMessage, e.localizedDescription)
                ACMBaseLogger.warning(errorMessage)
                onError?(ACMBaseNetworkError(message: self.errorMessage, log: errorMessage, endpoint: endpoint))
            }
        }
        dataTask.resume()
    }
}
