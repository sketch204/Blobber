# Blobber

This is a simple blob management library. It can store `Data` blobs in memory or on disk.

### Usage

```Swift
// Create a Blobber
let blobber = Blobber()

// Save some data to it
let blob = blobber.store(data)

// Retrieve it later using the generated ID
let blobAgain = blobber.blob(for: blob.id)

// Blobber also has built-in support for `NSImage` and `UIImage` instances.
let imageBlob = blobber.store(image)
```

`Blobber` doesn't handle the actual saving to disk, and instead defers that to a `BlobberPersistenceManager` instance. By default it is created with a `FilePersistenceManager`, which is why it will **default to saving blobs to disk**.

If you want to store blobs in memory, you can instead use the `MemoryPersistenceManager`.

```Swift
let memoryBlobber = Blobber(persistenceManager: MemoryPersistenceManager())
```  

By default, `FilePersistenceManager` will save blobs at the root of the documents directory. You can customize that as well.

```Swift
let customLocationBlobber = Blobber(
    persistenceManager: FilePersistenceManager(
        baseUrl: someCustomDirectory
    )
)
```

You can also provide a custom persistence manager by implementing the `BlobberPersistenceManager` protocol. All methods are `async throws` so you could even store data remotely somewhere.

```Swift
class MemoryPersistenceManager: BlobberPersistenceManager {
    func data(for id: Blob.ID) async throws -> Data? {
        // fetch...
    }
    
    func save(data: Data, for id: Blob.ID) async throws {
        // save...
    }
}
```
