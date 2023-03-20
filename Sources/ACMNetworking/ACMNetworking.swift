//
//  ACMNetworking.swift
//

import Foundation

public class ACMNetworking {
    open var errorMessage = "An error occurred."
    open var responseInfoMessage = "RESPONSE:"
    open var responseNullMessage = "Response null"
    open var dataNullMessage = "Data null"
    open var dataParseSuccessMessage = "Data parsed successfully"
    open var dataParseErrorMessage = "Data parsing error : %@"
    open var urlRequestErrorMessage = "URL Request Error"
    open var httpStatusError = "HTTP Status error"
    open var httpURLMessage = "HTTP URL:"
    open var httpAuthHeadersMessage = "HTTP AUTH HEADERS:"
    open var httpHeadersMessage = "HTTP HEADERS:"
    open var httpQueryItemsMessage = "HTTP QUERYITEMS:"
    open var httpBodyMessage = "HTTP BODY:"
    open var httpRequestType = "HTTP Request TYPE:"

    public init() {}

    public func baseRequest(to endpoint: ACMBaseEndpoint) -> URLRequest? {
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

    public func request<T: Decodable>(to endpoint: ACMBaseEndpoint, completion: @escaping (ACMBaseResult<T, Error>) -> Void) {
        guard let urlRequest = baseRequest(to: endpoint) else {
            ACMBaseLogger.error(urlRequestErrorMessage)
            return
        }

        let dataTask = endpoint.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                return
            }

            guard error == nil else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    error?.localizedDescription ?? "",
                ])
                ACMBaseLogger.error(message)
                completion(.failure(ACMBaseNetworkError(message: self.errorMessage, log: error?.localizedDescription, endpoint: endpoint)))
                return
            }
            guard response != nil else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.responseNullMessage,
                ])
                ACMBaseLogger.error(message)
                completion(.failure(ACMBaseNetworkError(message: self.errorMessage, log: self.responseNullMessage, endpoint: endpoint)))
                return
            }
            guard let data = data else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                completion(.failure(ACMBaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint)))
                return
            }

            if error?.isConnectivityError ?? false {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                completion(.failure(ACMBaseNetworkError(message: self.errorMessage, log: self.dataNullMessage, endpoint: endpoint)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                let message = ACMStringUtils.shared.merge(list: [
                    self.errorMessage,
                    self.httpStatusError,
                ])
                ACMBaseLogger.error(message)
                completion(.failure(ACMBaseNetworkError(message: self.errorMessage, log: self.httpStatusError, endpoint: endpoint)))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)

                let info = ACMStringUtils.shared.merge(list: [
                    self.responseInfoMessage,
                    String(data: data, encoding: .utf8) ?? "",
                ])
                ACMBaseLogger.info(info)
                completion(.success(responseObject))
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
                completion(.failure(ACMBaseNetworkError(message: self.errorMessage, log: errorMessage, endpoint: endpoint)))
            }
        }
        dataTask.resume()
    }
}
