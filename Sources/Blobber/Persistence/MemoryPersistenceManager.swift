import Foundation

public class MemoryPersistenceManager {
    private var storage: [Blob.ID: Data] = [:]
    
    public init() {}
}

extension MemoryPersistenceManager: BlobberPersistenceManager {
    public func data(for id: Blob.ID) async throws -> Data? {
        storage[id]
    }
    
    public func save(data: Data, for id: Blob.ID) async throws {
        storage[id] = data
    }
}
