import HTTP
import JWT
import AuthProvider

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
}
