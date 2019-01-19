import Foundation
import HTTP

public struct URLRequestDescriptor {
    public let url: URL
    public let method: HTTPMethod
    public let headers: HTTPHeaders
    public let parameters: [String: Any]
    public let httpVersion: HTTPVersion
}
