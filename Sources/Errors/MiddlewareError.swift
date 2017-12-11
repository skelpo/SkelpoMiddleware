import Vapor

public enum MiddlewareError: Error {
    case middlewareNotRegistered(Middleware.Type)
}
