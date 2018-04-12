import JWTProvider
import Fluent
import Crypto
import Vapor
import JWT

public final class JWTAuthenticatableMiddlware<A: JWTAuthenticatable>: Middleware where A.Database: QuerySupporting {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let jwt = try request.make(JWTService.self)
        
        if try request.isAuthenticated(A.self) {
            return try next.respond(to: request)
            
        } else if let payload = request.http.headers.basicAuthorization {
            let futureUser = try A.query(on: request).filter(A.usernameKey == payload.username).first().unwrap(
                or: Abort(.notFound, reason: "No user exists with the username '\(payload.username)'")
            )
            
            var user: A!
            return futureUser.flatMap(to: String.self) { (found) in
                if try BCrypt.verify(payload.password, created: found.password) {
                    user = found
                    return try found.accessToken(on: request)
                } else {
                    throw Abort(.unauthorized, reason: "")
                }
                }.flatMap(to: Response.self) { (token) in
                    let payload = try JWT<A.Payload>.init(from: Data(token.utf8), verifiedUsing: jwt.signer).payload
                    
                    try request.authenticate(user)
                    try request.set("skelpo-payload", to: payload)
                    
                    return try next.respond(to: request)
            }
            
        } else if request.http.headers.bearerAuthorization != nil {
            let payload: A.Payload = try request.payload()
            
            return try A.find(payload.id, on: request).unwrap(
                or: Abort(.notFound, reason: "No user found with the ID from the access token")
                ).flatMap(to: Response.self, { (model) in
                    try request.authenticate(model)
                    try request.set("skelpo-payload", to: payload)
                    
                    return try next.respond(to: request)
                })
            
        } else {
            throw Abort(.unauthorized, reason: "No authorized user to data to authorize a user was found")
        }
    }
}

