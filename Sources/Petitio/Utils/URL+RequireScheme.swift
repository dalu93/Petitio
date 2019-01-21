import Foundation

extension URL {
    func requireScheme() throws -> HTTPScheme {
        guard let scheme = scheme else {
            throw Error.missingURLScheme
        }

        switch scheme.lowercased() {
        case "http":
            return .http

        case "https":
            return .https

        case "ws":
            return .ws

        case "wss":
            return .wss

        default:
            throw Error.unsupportedScheme
        }
    }
}
