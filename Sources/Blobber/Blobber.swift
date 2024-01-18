import Foundation

public struct Blobber {
    public let persistenceManager: BlobberPersistenceManager
}

extension Blobber {
    public func store(_ data: Data, for id: Blob.ID? = nil) async throws -> Blob {
        let id = id ?? Blob.ID()
        try await persistenceManager.save(data: data, for: id)
        return Blob(id: id, data: data)
    }
}

extension Blobber {
    public func blob(for id: Blob.ID) async throws -> Blob? {
        let data = try await persistenceManager.data(for: id)
        return data.map { Blob(id: id, data: $0) }
    }
}
