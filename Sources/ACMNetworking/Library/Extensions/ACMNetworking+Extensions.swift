//
//  ACMNetworking+Extensions.swift
//

import Foundation

extension ACMNetworking {
    func baseRequest(to endpoint: ACMBaseEndpoint) -> URLRequest? {
        guard let urlRequest = endpoint.urlRequest else {
            endpoint.logger?.error(ACMNetworkConstants.urlRequestErrorMessage)
            return nil
        }

        var infoList = [
            ACMNetworkConstants.httpRequestType,
        ]

        if let methodRaw = endpoint.method?.rawValue {
            infoList.append(methodRaw)
        }

        let info = endpoint.stringUtils?.merge(list: infoList)
        endpoint.logger?.info(info)

        if let url = endpoint.url {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpURLMessage,
                "\(url)",
            ])
            endpoint.logger?.info(info)
        }

        if let authHeader = endpoint.authHeader {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpAuthHeadersMessage,
                "\(authHeader)",
            ])
            endpoint.logger?.info(info)
        }

        if let headers = endpoint.headers, headers.count > 0 {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpHeadersMessage,
                "\(headers)",
            ])
            endpoint.logger?.info(info)
        }

        if let queryItems = endpoint.queryItems, queryItems.count > 0 {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpQueryItemsMessage,
                "\(queryItems)",
            ])
            endpoint.logger?.info(info)
        }

        if let params = endpoint.params {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                params.paramsRaw,
            ])
            endpoint.logger?.info(info)
        } else if let data = endpoint.mediaData {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                String(format: ACMNetworkConstants.httpBodyMultipart, "\(data.length)"),
            ])
            endpoint.logger?.info(info)
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
        let message = mainEndpoint?.stringUtils?.merge(list: [
            "didFinishCollecting",
            task.description,
            "metrics",
            "\(metrics.taskInterval)",
        ])
        logger?.info(message)
    }

    /// URL Session taskIsWaitingForConnectivity
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    public func urlSession(_: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        let message = mainEndpoint?.stringUtils?.merge(list: [
            "taskIsWaitingForConnectivity",
            task.description,
        ])
        logger?.info(message)
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
        let message = mainEndpoint?.stringUtils?.merge(list: [
            "task",
            task.description,
            "didSendBodyData",
            "\(bytesSent)",
            "totalBytesSent",
            "\(totalBytesSent)",
            "totalBytesExpectedToSend",
            "\(totalBytesExpectedToSend)",
        ])
        logger?.info(message)
    }
}
