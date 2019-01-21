import Foundation

public struct EmptyBody: LosslessHTTPBodyRepresentable {
    public init() {}

    public func convertToHTTPBody() -> HTTPBody {
        return HTTPBody()
    }
}
