import Vapor
import HTTP

public final class APIErrorMiddleware: Middleware {
    
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let message: String
        let status: Status?
        do {
            return try next.respond(to: request)
        } catch let error as AbortError {
            message = error.reason
            status = error.status
        } catch let error as CustomStringConvertible {
            message = error.description
            status = nil
        } catch {
            message = "\(error)"
            status = nil
        }
        return try Response(status: status ?? .badRequest, headers: [.contentType: "application/json"], body: JSON(node: ["error": message]))
        
    }
}

