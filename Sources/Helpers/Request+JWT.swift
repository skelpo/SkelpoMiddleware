import Vapor
import JWT
import Authentication
import Errors
import Crypto
import Foundation

public let teamMiddlewareKey = "team_id_middleware_registered"

extension Request {
    public func getJWT()throws -> String {
        guard let bearer = self.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        return bearer
    }
    
    public func payload<Payload: JWTPayload>(as payloadType: Payload.Type)throws -> Payload {
        guard let payload = try self.get("skelpo-payload") as? Payload else {
            throw SkelpoMiddlewareError.middlewareNotRegistered("JWTAuthenticationMiddleware")
        }
        return payload
    }
    
    @discardableResult
    public func teams(_ teams: [Int]? = nil)throws -> [Int] {
        let session = try self.session()
        if let ids = teams {
            session.data.storage["teams"] = ids
        }
        
        if let teams: [Int] = session.data.storage["teams"] as? [Int] {
            return teams
        } else if let teams = try self.get("skelpo_teams") as? [Int] {
            return teams
        } else {
            if let _ = try self.get(teamMiddlewareKey) {
                return []
            } else {
                throw SkelpoMiddlewareError.middlewareNotRegistered("TeamIDMiddleware")
            }            
        }
    }
}
