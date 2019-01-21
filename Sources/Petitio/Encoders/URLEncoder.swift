import Foundation

public struct URLEncoder: RequestEncoder {
    public init() {}

    public func encode(_ request: URLRequestDescriptor) throws -> HTTPRequest {
        var queryElements: [String] = []
        request.parameters.forEach { args in
            queryElements.append("\(args.key)=\(args.value)")
        }

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

            newQuery.append(queryElements.joined(separator: "&"))
            separatedURL[1] = newQuery
        } else if separatedURL.count == 1 {
            // A query does not exist
            newQuery.append(queryElements.joined(separator: "&"))
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
