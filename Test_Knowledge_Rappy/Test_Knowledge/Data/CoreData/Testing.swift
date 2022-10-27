
import Foundation
import CoreData

extension NSManagedObjectModel {
    static let sharedModel: NSManagedObjectModel = {
        let url = Bundle(for: PersistentContainer.self).url(forResource: "Test_Knowledge", withExtension: "momd")!
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Managed object model could not be created.")
        }
        return managedObjectModel
    }()
}
