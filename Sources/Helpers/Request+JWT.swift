import HTTP
import JWT
import AuthProvider
import JWTProvider
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
        guard let payload = self.storage["skelpo-payload"] as? JSON else {
            throw MiddlewareError.middlewareNotRegistered("JWTAuthenticationMiddleware")
        }
        return payload
    }
    
    @discardableResult
    public func teams(_ teams: [Int]? = nil)throws -> [Int] {
        let session = try self.assertSession()
        if let ids = teams {
            try session.data.set("teams", ids)
        }
        
        if let teams: [Int] = try session.data.get("teams") {
            return teams
        } else if let teams = self.storage["skelpo_teams"] as? [Int] {
            return teams
        } else {
            throw MiddlewareError.middlewareNotRegistered("TeamIDMiddleware")
        }
    }
}
