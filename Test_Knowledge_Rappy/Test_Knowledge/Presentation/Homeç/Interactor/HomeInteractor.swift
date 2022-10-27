//
//  HomeInteractor.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import Foundation
import CoreData

public protocol HomeInteractorProtocol {
    func getListMoviesServer(by listId: String, language: String) -> Observable<MoviesModel.Movies>
    func saveFilmsCoreData(movies: MoviesModel.Movies, movieType: MovieType)
    func listAllMoviesFetchRequest() -> [Films]
    func listRecommendedMoviesFetchRequest(by date: Date) -> [Films]
    func containsRecordsInFetchRequest() -> Bool
}

public class HomeInteractor: Interactor, HomeInteractorProtocol {
    
    public func getListMoviesServer(by listId: String, language: String) -> Observable<MoviesModel.Movies> {
        return (repository as! ServiceRepository).getMovies(listId: listId, language: language).map{$0.mapper()}
    }
    
    public func saveFilmsCoreData(movies: MoviesModel.Movies, movieType: MovieType){
        movies.results.forEach { movie in
            DownloadImage.downloaded(from: movie.posterPath) { data in
                let film = Films(context: PersistentContainer.shared.viewContext)
                film.originalTitle = movie.originalTitle
                film.movieId = movie.id
                film.releaseDate = movie.releaseDate.toDate()
                film.originalLanguage = movie.originalLanguage
                film.posterPath = movie.posterPath
                film.type = movieType.rawValue
                film.posterBase64Encoded = data
                do {
                    try PersistentContainer.shared.viewContext.saveIfNeeded()
                } catch {
                    PersistentContainer.shared.viewContext.delete(film)
                }
            }
        }
    }
    
    public func listAllMoviesFetchRequest() -> [Films]{
        let fetchRequest = Films.fetchRequest
        fetchRequest.propertiesToFetch = [
            #keyPath(Films.originalTitle)
        ]
        return try! PersistentContainer.shared.viewContext.fetch(fetchRequest)
    }
    
    public func listRecommendedMoviesFetchRequest(by date: Date) -> [Films]{
        let fetchRequest = Films.fetchRequest
        fetchRequest.propertiesToFetch = [
            #keyPath(Films.originalTitle)
        ]
        fetchRequest.fetchLimit = 6
        fetchRequest.predicate = NSPredicate(format: "releaseDate >= %@ AND type = %@",  argumentArray: [date as CVarArg, MovieType.topRantedMovies.rawValue])
        return try! PersistentContainer.shared.viewContext.fetch(fetchRequest)
    }
    
    public func containsRecordsInFetchRequest() -> Bool{
        let fetchRequest: NSFetchRequest<Films>  = Films.fetchRequest
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Films.originalTitle, ascending: false)]
        return try! PersistentContainer.shared.viewContext.fetch(fetchRequest).count > 0
    }
}
