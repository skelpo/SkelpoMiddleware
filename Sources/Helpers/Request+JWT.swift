import Vapor
import Authentication
import Errors
import Foundation

public let teamMiddlewareKey = "team_id_middleware_registered"

extension Request {
    public func getJWT()throws -> String {
        guard let bearer = self.http.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        return bearer
    }
    
    public func payload<Payload: Decodable>(as payloadType: Payload.Type)throws -> Payload {
        guard let data = try self.get("skelpo-payload") as? Data else {
            throw SkelpoMiddlewareError.middlewareNotRegistered("JWTAuthenticationMiddleware")
        }
        return try JSONDecoder().decode(Payload.self, from: data)
    }
    
    @discardableResult
    public func teams(_ teams: [Int]? = nil)throws -> [Int] {
        let session = try self.session()
        if let ids = teams {
            try session.set("teams", to: ids)
        }
        
        if let teams: [Int] = try session.get("teams", as: [Int]?.self) {
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
