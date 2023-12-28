//
//  ACMEncryptionUtils.swift
//
//
//  Created by burak on 28.12.2023.
//

import CommonCrypto
import Foundation

final class ACMEncryptionUtils {
    func encrypt(value: Any, type: ACMEncryptType) -> Any {
        let stringRaw = String(describing: value)

        switch type {
        case .plain:
            return value
        case .md5:
            return md5(with: stringRaw)
        case .base64:
            return base64(with: stringRaw)
        case .sha1:
            return sha1(with: stringRaw)
        case .sha256:
            return sha256(with: stringRaw)
        case .sha384:
            return sha384(with: stringRaw)
        case .sha512:
            return sha512(with: stringRaw)
        }
    }

    private func sha1(with string: String) -> String {
        if let data = string.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            _ = data.withUnsafeBytes {
                CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
        return ""
    }

    private func sha256(with string: String) -> String {
        if let data = string.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            _ = data.withUnsafeBytes {
                CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
        return ""
    }

    private func sha384(with string: String) -> String {
        if let data = string.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
            _ = data.withUnsafeBytes {
                CC_SHA384($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
        return ""
    }

    private func sha512(with string: String) -> String {
        if let data = string.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
            _ = data.withUnsafeBytes {
                CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
        return ""
    }

    private func md5(with string: String) -> String {
        if let data = string.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes {
                CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
        return ""
    }

    private func base64(with string: String) -> String {
        if let data = string.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return ""
    }
}
