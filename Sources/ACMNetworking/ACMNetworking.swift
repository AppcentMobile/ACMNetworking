//
//  ACMNetworking.swift
//

import Foundation

public class ACMNetworking {
    private var task: URLSessionDataTask?

    public init() {}

    public func request<T: Decodable>(to endpoint: ACMBaseEndpoint,
                                      onSuccess: ACMGenericCallbacks.ResponseCallback<T>,
                                      onError: ACMGenericCallbacks.ErrorCallback)
    {
        guard let urlRequest = baseRequest(to: endpoint) else {
            ACMBaseLogger.error(ACMNetworkConstants.urlRequestErrorMessage)
            return
        }

        task = endpoint.session.dataTask(with: urlRequest) { data, response, error in
            defer {
                self.task = nil
            }

            guard error == nil else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    error?.localizedDescription ?? "",
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
                return
            }
            guard response != nil else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.responseNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.responseNullMessage, endpoint: endpoint))
                return
            }
            guard let data = data else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
                return
            }

            if error?.isConnectivityError ?? false {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.httpStatusError,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
                return
            }
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.httpStatusError,
                    "-\(httpResponse.statusCode)",
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)

                let info = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.responseInfoMessage,
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
                let errorMessage = String(format: ACMNetworkConstants.dataParseErrorMessage, e.localizedDescription)
                ACMBaseLogger.warning(errorMessage)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: errorMessage, endpoint: endpoint))
            }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}
