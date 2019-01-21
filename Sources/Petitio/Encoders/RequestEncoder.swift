import Foundation

public protocol RequestEncoder {
    func encode(_ request: URLRequestDescriptor) throws -> HTTPRequest
}
