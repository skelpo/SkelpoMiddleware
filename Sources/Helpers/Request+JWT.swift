import Store
import HTTP
import JWT
import AuthProvider
import JWTProvider

extension Request {
    public func parseJWT() throws -> JWT {
        guard let authHeader = auth.header else {
            throw AuthenticationError.noAuthorizationHeader
        }
        
        guard let bearer = authHeader.bearer else {
            throw AuthenticationError.invalidBearerAuthorization
        }
        
        return try JWT(token: bearer.string)
    }
    
    public var payload: JSON {
        return jwtPayload!
    }
}
