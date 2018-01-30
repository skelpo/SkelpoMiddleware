import Vapor
import HTTP
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
        
        let content = try JSONEncoder().encode(["error": message])
        
        let headers: HTTPHeaders = [.contentType: "application/json"]
        let body = HTTPBody(content)
        
        let httpResponse = HTTPResponse(
            status: status ?? .badRequest,
            headers: headers,
            body: body
        )
        let response = Response(http: httpResponse, using: request.superContainer)
        
        return Future(response)
    }
}
