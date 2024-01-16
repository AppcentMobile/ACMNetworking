//
//  ACMNetworking.swift
//

import Foundation

/// ACMNetworking, make requests easily
public class ACMNetworking: NSObject {
    var mainEndpoint: ACMBaseEndpoint?
    var session: URLSession?
    var requestTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    var taskProgress: NSKeyValueObservation?

    /// Predefined variables
    var logger: ACMBaseLogger? {
        mainEndpoint?.logger
    }

    public var stringUtils: ACMStringUtils? {
        mainEndpoint?.stringUtils
    }

    public var plistUtils: ACMPlistUtils? {
        mainEndpoint?.plistUtils
    }

    /// Public Init function
    /// For creating object with SDK
    override public init() {
        super.init()
    }

    /// Cancels the current network request
    public func cancel() {
        cancelRequestTask()
        cancelDownloadTask()
        session?.invalidateAndCancel()
        session = nil
        taskProgress?.invalidate()
        taskProgress = nil
        mainEndpoint = nil
    }

    private func cancelRequestTask() {
        if requestTask?.state == .running {
            requestTask?.cancel()
        }
        requestTask = nil
    }

    private func cancelDownloadTask() {
        if downloadTask?.state == .running {
            downloadTask?.cancel()
        }
        downloadTask = nil
    }
}
