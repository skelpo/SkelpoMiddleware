import Vapor
import Debugging
import Foundation

public struct SkelpoMiddlewareError: Debuggable, AbortError {
    public let identifier: String
    public let status: HTTPStatus
    public let reason: String
    
    public init(identifier: String, status: HTTPStatus, reason: String) {
        self.identifier = identifier
        self.status = status
        self.reason = reason
    }
}

extension SkelpoMiddlewareError {
    public static func middlewareNotRegistered(_ middleware: String) -> SkelpoMiddlewareError {
        return self.init(identifier: "middlewareNotRegistered", status: .internalServerError, reason: "Make sure you register \(middleware) with your routes")
    }
}
