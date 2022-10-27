

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {

    static let shared = PersistentContainer(name: "Test_Knowledge", managedObjectModel: .sharedModel)
  
    func setup() {
        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

    }
}
