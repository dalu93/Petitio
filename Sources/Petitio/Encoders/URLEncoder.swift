import Foundation
import HTTP

public struct URLEncoder: RequestEncoder {
    public init() {}

    public func encode(_ request: URLRequestDescriptor) throws -> HTTPRequest {
        let generatedQuery = request
            .parameters
            .reduce("", { partial, param in
                let (key, value) = param
                guard let stringValue = value as? String else {
                    return partial
                }

                return partial + key + "=" + stringValue + "&"
            })

        var separatedURL = request
            .url
            .absoluteString
            .components(separatedBy: "?")

        var newQuery = ""
        if separatedURL.count == 2 {
            // A query already exists
            newQuery = separatedURL[1]
            if newQuery.last != "&" {
                newQuery.append("&")
            }

            newQuery.append(generatedQuery)
            separatedURL[1] = newQuery
        } else if separatedURL.count == 1 {
            // A query does not exist
            newQuery.append(generatedQuery)
            separatedURL.append(newQuery)
        } else {
            throw Error.invalidURL
        }

        let newURLAbsoluteString = separatedURL.joined(separator: "?")
        guard let newURL = URL(string: newURLAbsoluteString) else {
            throw Error.invalidURL
        }

        let httpRequest = HTTPRequest(
            method: request.method,
            url: newURL,
            version: request.httpVersion,
            headers: request.headers,
            body: EmptyBody()
        )

        return httpRequest
    }
}
