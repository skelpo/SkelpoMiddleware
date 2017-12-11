import Store
import HTTP
import JWT
import AuthProvider
import JWTProvider
import AuthMiddleware
import APIMiddleware
import Errors

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
    
    public func payload()throws -> JSON {
        guard let payload = jwtPayload else {
            throw MiddlewareError.middlewareNotRegistered(JWTAuthenticationMiddleware.self)
        }
        return payload
    }
    
    public func teams()throws -> [Int] {
        guard let teams = teamIDs else {
            throw MiddlewareError.middlewareNotRegistered(TeamIDMiddleware.self)
        }
        return teams
    }
}
