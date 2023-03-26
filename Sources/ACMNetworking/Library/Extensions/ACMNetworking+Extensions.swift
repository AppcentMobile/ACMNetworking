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

        if let params = endpoint.params {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                params.paramsRaw,
            ])
            ACMBaseLogger.info(info)
        } else if let data = endpoint.mediaData {
            let info = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                String(format: ACMNetworkConstants.httpBodyMultipart, "\(data.length)"),
            ])
            ACMBaseLogger.info(info)
        }

        return urlRequest
    }
}

extension ACMNetworking: URLSessionTaskDelegate {
    /// URL Session didFinishCollecting
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    ///     - didFinishCollecting: Metrics that gathered
    public func urlSession(_: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        let message = ACMStringUtils.shared.merge(list: [
            "didFinishCollecting",
            task.description,
            "metrics",
            "\(metrics.taskInterval)",
        ])
        ACMBaseLogger.info(message)
    }

    /// URL Session taskIsWaitingForConnectivity
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    public func urlSession(_: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        let message = ACMStringUtils.shared.merge(list: [
            "taskIsWaitingForConnectivity",
            task.description,
        ])
        ACMBaseLogger.info(message)
    }

    /// URL Session didSendBodyData
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    ///     - bytesSent: DidSendBodyData
    ///     - totalBytesSent
    ///     - totalBytesExpectedToSend
    public func urlSession(_: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let message = ACMStringUtils.shared.merge(list: [
            "task",
            task.description,
            "didSendBodyData",
            "\(bytesSent)",
            "totalBytesSent",
            "\(totalBytesSent)",
            "totalBytesExpectedToSend",
            "\(totalBytesExpectedToSend)",
        ])
        ACMBaseLogger.info(message)
    }
}
