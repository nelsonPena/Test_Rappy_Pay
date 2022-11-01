//
//  MockDownloadImage.swift
//  Test_KnowledgeTests
//
//  Created by Nelson Peña on 1/11/22.
//

import Foundation

import Foundation
@testable import Test_Knowledge

final class InteractorDetailViewControllerTest: MovieDetailInteractorProtocol, RestApiImplMockable {
   
    func getMovieDetailServer(of movieId: String, language: String) -> RxSwift.Observable<MovieDetailModel> {
        return ServiceDataRepositoryTest(filename: filename).getMoviesDetail(movieId: movieId, language: language).map{$0.mapper()}
    }
    
    func getVideosMovie(of movieId: String, language: String) -> RxSwift.Observable<VideosModel.Videos> {
        return ServiceDataRepositoryTest(filename: "MoviesVideosList").getVideosMovie(movieId: "", language: "").map{$0.mapper()}
    }
    
    func downloadBackgroundImage(posterPath: String, _ completion: @escaping (String) -> Void) {
        completion(ServiceDataRepositoryTest(filename: "response").downloadImage())
    }
  
    var bunble: Bundle
    var filename: String
    
    init(filename: String) {
        self.filename = filename
        self.bunble = Bundle(for: type(of: self))
    }
}
