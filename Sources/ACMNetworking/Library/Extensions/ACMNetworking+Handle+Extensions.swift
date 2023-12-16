//
//  ACMNetworking+Handle+Extensions.swift
//
//
//  Created by Burak on 16.12.2023.
//

import Foundation

extension ACMNetworking {
    func generateURLRequest(endpoint: ACMBaseEndpoint) -> URLRequest? {
        guard let urlRequest = baseRequest(to: endpoint) else {
            ACMBaseLogger.error(ACMNetworkConstants.urlRequestErrorMessage)
            return nil
        }
        return urlRequest
    }
}

extension ACMNetworking {
    /// Handle if error occures
    func handleNilErrorResponse(with endpoint: ACMBaseEndpoint, error: Error?, onError: ACMGenericCallbacks.ErrorCallback) {
        guard error == nil else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                error?.localizedDescription ?? "",
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
            return
        }
    }
}

extension ACMNetworking {
    /// Handle if response is nil
    func handleNilResponse(with endpoint: ACMBaseEndpoint, response: URLResponse?, onError: ACMGenericCallbacks.ErrorCallback) {
        guard response != nil else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.responseNullMessage,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.responseNullMessage, endpoint: endpoint))
            return
        }
    }
}

extension ACMNetworking {
    /// Handle some connectivity error occures
    func handleConnectivityError(with endpoint: ACMBaseEndpoint, error: Error?, onError: ACMGenericCallbacks.ErrorCallback) {
        if error?.isConnectivityError ?? false {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.dataNullMessage,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
            return
        }
    }
}

extension ACMNetworking {
    /// Handle response data
    func handleData(with endpoint: ACMBaseEndpoint, data: Data?, onError: ACMGenericCallbacks.ErrorCallback) -> Data? {
        guard let data = data else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.dataNullMessage,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
            return nil
        }
        return data
    }
}

extension ACMNetworking {
    /// Handle http response
    func handleHttpResponse(with endpoint: ACMBaseEndpoint, response: URLResponse?, onError: ACMGenericCallbacks.ErrorCallback) -> HTTPURLResponse? {
        guard let httpResponse = response as? HTTPURLResponse else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.httpStatusError,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
            return nil
        }
        return httpResponse
    }
}

extension ACMNetworking {
    /// Validates response with http success statuses
    func validateResponse(with httpResponse: HTTPURLResponse) -> Bool {
        return 200 ..< 300 ~= httpResponse.statusCode
    }
}

extension ACMNetworking {
    /// Execute retry mechanism
    func executeRetry<T: Decodable>(with endpoint: ACMBaseEndpoint, httpResponse: HTTPURLResponse, data: Data, currentRetryCount: Int?, onSuccess: ACMGenericCallbacks.ResponseCallback<T>, onError: ACMGenericCallbacks.ErrorCallback) {
        let message = ACMStringUtils.shared.merge(list: [
            ACMNetworkConstants.errorMessage,
            ACMNetworkConstants.httpStatusError,
            "-\(httpResponse.statusCode)",
            ACMNetworkConstants.responseInfoMessage,
            String(data: data, encoding: .utf8) ?? "",
        ])
        ACMBaseLogger.error(message)

        // MARK: Retry mechanism

        guard let maxRetryCount = endpoint.retryCount else {
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
            cancel()
            return
        }

        if let currentRetryCount = currentRetryCount, currentRetryCount < maxRetryCount {
            let nextRetryCount = currentRetryCount + 1
            ACMBaseLogger.info(ACMStringUtils.shared.merge(list: [
                String(format: ACMNetworkConstants.httpRetryCount, nextRetryCount, maxRetryCount),
            ]))
            request(to: endpoint, currentRetryCount: nextRetryCount, onSuccess: onSuccess, onError: onError)
        } else {
            cancel()
        }
    }
}

extension ACMNetworking {
    /// Handle server response
    func handleResult<T: Decodable>(with endpoint: ACMBaseEndpoint, data: Data, onSuccess: ACMGenericCallbacks.ResponseCallback<T>, onError: ACMGenericCallbacks.ErrorCallback) {
        do {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.responseInfoMessage,
                String(data: data, encoding: .utf8) ?? "",
            ])
            ACMBaseLogger.info(info)

            let responseObject = try JSONDecoder().decode(T.self, from: data)
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
            let errorMessage = String(format: ACMNetworkConstants.dataParseErrorMessage, e.localizedDescription)
            ACMBaseLogger.warning(errorMessage)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: errorMessage, endpoint: endpoint))
        }
    }
}
