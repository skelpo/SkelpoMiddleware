import JWTProvider
import Helpers
import Vapor
import JWT

public final class JWTAuthenticationMiddleware<Payload: JWTPayload>: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let payload: Payload = try request.payload()
        
        try request.set("skelpo-payload", to: payload)
        return try next.respond(to: request)
    }
}
