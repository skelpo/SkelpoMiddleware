import Vapor
import Helpers
import Store

public final class TeamIDMiddleware: Middleware {
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let payload = try request.payload()
        let teams: [Int] = try payload.get("team_ids")
        request.storage["skelpo_teams"] = teams
        
        return try next.respond(to: request)
    }
}
