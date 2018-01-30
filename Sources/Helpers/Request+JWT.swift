import Vapor
import JWT
import Authentication
import Errors
import Crypto
import Foundation

public let teamMiddlewareKey = "team_id_middleware_registered"

extension Request {
    public func parseJWT<Payload: JWTPayload>(to payloadType: Payload.Type) throws -> JWT<Payload> {
        guard let bearer = self.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        let encoded = Base64Encoder().encode(string: bearer)
        guard let sig = Data(base64Encoded: encoded) else {
            throw Abort(.badRequest)
        }
        
        return try JWT(unverifiedFrom: sig)
    }
    
    public func payload<Payload>(as payloadType: Payload.Type)throws -> Payload {
        guard let payload = try self.get("skelpo-payload") else {
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
