import Vapor
import JWT
import Helpers
import Foundation

public final class JWTAuthenticationMiddleware<Payload: JWTPayload>: Middleware {
    let signerAlgorithm: JWTAlgorithm
    
    public init(algorithm: JWTAlgorithm) {
        self.signerAlgorithm = algorithm
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let accessToken = try request.getJWT()
        let signer = JWTSigner(algorithm: signerAlgorithm)
        let jwt = try JWT<Payload>(from: accessToken, verifiedUsing: signer)
        
        try request.set("skelpo-payload", to: JSONEncoder().encode(jwt.payload))
        
        return try next.respond(to: request)
    }
}
