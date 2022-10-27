
import Foundation
import CoreData

extension NSManagedObjectContext {

    var hasPersistentChanges: Bool {
        return !insertedObjects.isEmpty || !deletedObjects.isEmpty || updatedObjects.contains(where: { $0.hasPersistentChangedValues })
    }
    
    @discardableResult public func saveIfNeeded() throws -> Bool {
        let hasPurpose = parent != nil || persistentStoreCoordinator?.persistentStores.isEmpty == false
        guard hasPersistentChanges && hasPurpose else {
            return false
        }

        try save()

        return true
    }
}
