import Vapor
import Foundation

public final class APIErrorMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let message: String
        let status: HTTPStatus?
        
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
        
        let httpResponse = try HTTPResponse(
            status: status ?? .badRequest,
            headers: [.contentType: "application/json"],
            body: ["error": message]
        )
        let response = Response(http: httpResponse, using: request.superContainer)
        
        return Future(response)
    }
}

extension Dictionary: HTTPBodyRepresentable where Key: Encodable, Value: Encodable {
    public func makeBody() throws -> HTTPBody {
        return try HTTPBody(JSONEncoder().encode(self))
    }
}
