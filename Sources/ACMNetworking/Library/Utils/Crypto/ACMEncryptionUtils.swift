//
//  ACMEncryptionUtils.swift
//
//
//  Created by burak on 28.12.2023.
//

import CryptoKit
import Foundation

final class ACMEncryptionUtils {
    func encrypt(value: Any, type: ACMEncryptType) -> Any {
        let stringRaw = String(describing: value)

        switch type {
        case .plain:
            return value
        case .md5:
            return md5(value: stringRaw)
        case .base64:
            return base64(value: stringRaw)
        case .sha1:
            return sha1(value: stringRaw)
        case .sha256:
            return sha256(value: stringRaw)
        case .sha384:
            return sha384(value: stringRaw)
        case .sha512:
            return sha512(value: stringRaw)
        }
    }

    private func md5(value: String) -> String {
        if #available(iOS 13, *) {
            return Insecure.MD5.hash(data: Data(value.utf8))
                .map {
                    String(format: encFormat, $0)
                }
                .joined()
        } else {
            return ""
        }
    }

    private func base64(value: String) -> String {
        if #available(iOS 13, *) {
            guard let data = Data(base64Encoded: value) else { return "" }
            guard let str = String(data: data, encoding: .utf8) else { return "" }
            return str
        } else {
            return ""
        }
    }

    private func sha1(value: String) -> String {
        if #available(iOS 13, *) {
            return Insecure.SHA1.hash(data: Data(value.utf8))
                .map {
                    String(format: encFormat, $0)
                }
                .joined()
        } else {
            return ""
        }
    }

    private func sha256(value: String) -> String {
        if #available(iOS 13, *) {
            guard let data = value.data(using: .utf8) else { return "" }
            return SHA256.hash(data: data)
                .map {
                    String(format: encFormat, $0)
                }
                .joined()
        } else {
            return ""
        }
    }

    private func sha384(value: String) -> String {
        if #available(iOS 13, *) {
            guard let data = value.data(using: .utf8) else { return "" }
            return SHA384.hash(data: data)
                .map {
                    String(format: encFormat, $0)
                }
                .joined()
        } else {
            return ""
        }
    }

    private func sha512(value: String) -> String {
        if #available(iOS 13, *) {
            guard let data = value.data(using: .utf8) else { return "" }
            return SHA512.hash(data: data)
                .map {
                    String(format: encFormat, $0)
                }
                .joined()
        } else {
            return ""
        }
    }

    private let encFormat = "%02hhx"
}
