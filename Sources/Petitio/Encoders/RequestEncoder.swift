import Foundation
import HTTP

public protocol RequestEncoder {
    func encode(_ request: URLRequestDescriptor) throws -> HTTPRequest
}
