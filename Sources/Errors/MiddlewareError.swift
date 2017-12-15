import Vapor
import HTTP

public enum MiddlewareError: AbortError {
    case middlewareNotRegistered(String)
    
    public var status: Status {
        switch self {
        case .middlewareNotRegistered: return .internalServerError
        }
    }
    
    public var reason: String {
        switch self {
        case let .middlewareNotRegistered(middleware): return "Make sure you register \(middleware) with your routes"
        }
    }
}
