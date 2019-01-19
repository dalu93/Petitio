import Foundation
import HTTP

public struct BodyJSONEncoder: RequestEncoder {
    public init() {}

    public func encode(_ request: URLRequestDescriptor) throws -> HTTPRequest {
        let body = try JSONSerialization.data(
            withJSONObject: request.parameters,
            options: []
        )

        return HTTPRequest(
            method: request.method,
            url: request.url,
            version: request.httpVersion,
            headers: request.headers,
            body: body
        )
    }
}
