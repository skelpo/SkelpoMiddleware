import Vapor
import JWT
import Authentication
import Errors
import Crypto
import Foundation

public let teamMiddlewareKey = "team_id_middleware_registered"

extension Request {
    public func parseJWT<T>(to payloadType: T.Type) throws -> JWT<T> {
        guard let bearer = self.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        let encoded = Base64Encoder().encode(string: bearer)
        guard let sig = Data(base64Encoded: encoded) else {
            throw Abort(.badRequest)
        }
        
        return try JWT(unverifiedFrom: sig)
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
            if let _ = self.storage[teamMiddlewareKey] {
                return []
            } else {
                throw MiddlewareError.middlewareNotRegistered("TeamIDMiddleware")
            }            
        }
    }
}
