import JWTProvider
import Foundation
import Helpers
import Vapor
import JWT

public final class JWTAuthenticationMiddleware<Payload: JWTPayload>: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let jwt = try request.make(JWTService.self)
        let accessToken = try request.getJWT()
        let payload = try JWT<Payload>(from: accessToken, verifiedUsing: jwt.signer).payload
        
        try request.set("skelpo-payload", to: payload)
        return try next.respond(to: request)
    }
}
