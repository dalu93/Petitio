import Foundation

public enum Error: Swift.Error {
    case invalidURL
    case missingURLScheme
    case missingHost
    case unsupportedScheme
    case cannotConnect
    case unsupportedEncoder
}
