//
//  ACMPlistUtils.swift
//

import Foundation

/// ACMPlistUtils
///
/// Utility class for plist
public final class ACMPlistUtils {
    public static let shared = ACMPlistUtils()

    public func config<T: Codable>(type _: T.Type? = ACMPlistModel) -> T? {
        guard let data = getData(), let plist = getList(with: data, type: T.self) else {
            throwFatalError(with: ACMPropertyListSerializationError.fileNotParsed)
            return nil
        }
        return plist
    }

    private func getData() -> Data? {
        guard let path = Bundle.main.path(forResource: ACMPListContants.fileName, ofType: ACMPListContants.fileExtension) else {
            throwFatalError(with: ACMPropertyListSerializationError.fileNotFound)
            return nil
        }
        let url = URL(fileURLWithPath: path)

        do {
            return try Data(contentsOf: url)
        } catch {
            throwFatalError(with: ACMPropertyListSerializationError.dataNotAvailable)
            return nil
        }
    }

    private func getList<T: Codable>(with data: Data, type: T.Type) -> T? {
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            throwFatalError(with: ACMPropertyListSerializationError.dataCorrupted(context: context))
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            throwFatalError(with: ACMPropertyListSerializationError.keyNotFound(key: key, context: context))
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            throwFatalError(with: ACMPropertyListSerializationError.valueNotFound(value: value, context: context))
            return nil
        } catch let DecodingError.typeMismatch(type, context) {
            throwFatalError(with: ACMPropertyListSerializationError.typeMismatch(type: type, context: context))
            return nil
        } catch {
            throwFatalError(with: ACMPropertyListSerializationError.modelNotParsed)
            return nil
        }
    }

    private func throwFatalError(with error: ACMPropertyListSerializationError) {
        if ACMNetworkingConstants.configOverride == false {
            fatalError(error.localizedDescription)
        }
    }
}
