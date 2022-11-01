//
//  ZemogaMobileHTTPClientTest.swift
//  ZemogaMobileTests
//
//  Created by Nelson Peña on 31/05/22.
//

import Foundation
@testable import Test_Knowledge

final class ServiceDataRepositoryTest: ServiceRepository, RestApiImplMockable {
    
    func downloadImage() -> String {
        return loadImage(filename: filename)
    }
    
    func getMovies(listId: String, language: String) -> RxSwift.Observable<MoviesEntity.Movies> {
        return loadJSON(filename: filename)
    }
    
    func getMoviesDetail(movieId: String, language: String) -> RxSwift.Observable<MovieDetailEntiy> {
        return loadJSON(filename: filename)
    }
    
    func getVideosMovie(movieId: String, language: String) -> RxSwift.Observable<VideosEntity.Videos> {
       return loadJSON(filename: filename)
    }
    
    var bunble: Bundle
    var filename: String
    
    init(filename: String) {
        self.filename = filename
        self.bunble = Bundle(for: type(of: self))
    }

}
