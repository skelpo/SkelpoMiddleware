import Vapor
import Helpers

public class Provider: Vapor.Provider {
    public static var repositoryName: String = "SkelpoMiddleware"
    
    public func register(_ services: inout Services) throws {
        services.register(isSingleton: true) { (container) -> (Storage) in
            return Storage()
        }
    }
    
    public func boot(_ worker: Container) throws {}
}
