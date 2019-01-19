import Foundation

extension URL {
    func requireHost() throws -> String {
        guard let host = host else {
            throw Error.missingHost
        }

        return host
    }
}
