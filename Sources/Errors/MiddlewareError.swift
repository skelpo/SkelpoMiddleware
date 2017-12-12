import Vapor

public enum MiddlewareError: Error {
    case middlewareNotRegistered(String)
}
