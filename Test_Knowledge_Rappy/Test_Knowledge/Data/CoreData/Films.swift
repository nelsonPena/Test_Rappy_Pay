
import Foundation
import CoreData

public final class Films: NSManagedObject, Identifiable {
    @NSManaged var posterPath: String
    @NSManaged var posterBase64Encoded: String
    @NSManaged var originalTitle: String
    @NSManaged var originalLanguage: String
    @NSManaged var releaseDate: Date
    @NSManaged var type: Int16
    @NSManaged var movieId: Int64
}
