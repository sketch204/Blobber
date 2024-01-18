import XCTest
@testable import Blobber

final class BlobberTests: XCTestCase {
    private var persistenceManager: MemoryPersistenceManager!
    var blobber: Blobber!
    
    // MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        persistenceManager = MemoryPersistenceManager()
        blobber = Blobber(persistenceManager: persistenceManager)
    }
    
    // MARK: - Test Cases
    
    func test_storeBlob_defaultId() async throws {
        let testData = "Hello, Blobber!".data(using: .utf8)!
        let blob = try await blobber.store(testData)
        
        // Verify the data is stored in the persistence manager
        let storedData = try XCTUnwrap(persistenceManager.storage[blob.id])
        XCTAssertEqual(storedData, testData)
    }
    
    func test_store_customID() async throws {
        let customID = Blob.ID()
        let testData = "Custom ID Blob".data(using: .utf8)!
        
        // Test storing a blob with a custom ID
        let blob = try await blobber.store(testData, for: customID)
        
        // Verify the data is stored in the persistence manager with the custom ID
        let storedData = try XCTUnwrap(persistenceManager.storage[customID])
        XCTAssertEqual(storedData, testData)
    }
    
    func test_store_overrideExistingID() async throws {
        let blobID = Blob.ID()
        
        persistenceManager = MemoryPersistenceManager(
            initialData: [blobID: "Initial Data".data(using: .utf8)!]
        )
        blobber = Blobber(persistenceManager: persistenceManager)
        
        let testData = "Overridden Data".data(using: .utf8)!
        
        // Test storing a blob with the same ID to override the existing one
        _ = try await blobber.store(testData, for: blobID)
        
        // Verify the data is overridden in the persistence manager
        let storedData = try XCTUnwrap(persistenceManager.storage[blobID])
        XCTAssertEqual(storedData, testData)
    }
    
    func test_blobFor() async throws {
        let id = Blob.ID()
        let testData = "Retrieve Blob Test".data(using: .utf8)!
        persistenceManager = MemoryPersistenceManager(
            initialData: [id: testData]
        )
        
        // Use a custom persistence manager with initial data for this test
        blobber = Blobber(persistenceManager: persistenceManager)
        
        // Test retrieving the stored blob
        let retrievedBlob = try await blobber.blob(for: id)
        
        // Verify the retrieved blob is not nil and has the correct data
        XCTAssertNotNil(retrievedBlob)
        XCTAssertEqual(retrievedBlob?.data, testData)
    }
    
    func test_blobFor_nonExistentID() async throws {
        // Test retrieving a non-existent blob
        let nonExistentID = Blob.ID()
        let retrievedBlob = try await blobber.blob(for: nonExistentID)
        
        // Verify that the retrieved blob is nil
        XCTAssertNil(retrievedBlob)
    }
}


// MARK: - Mock Persistence Manager

private final class MemoryPersistenceManager: BlobberPersistenceManager {
    var storage: [Blob.ID: Data] = [:]
    
    init(initialData: [Blob.ID: Data] = [:]) {
        self.storage = initialData
    }
    
    func data(for id: Blob.ID) async throws -> Data? {
        return storage[id]
    }
    
    func save(data: Data, for id: Blob.ID) async throws {
        storage[id] = data
    }
}
