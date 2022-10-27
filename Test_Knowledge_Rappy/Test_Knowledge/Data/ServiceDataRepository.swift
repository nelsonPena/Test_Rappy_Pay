//
//  ServiceDataRepository.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import Foundation
import RxSwift

public class ServiceDataRepository: ServiceRepository {
    public static let sharedInstance = ServiceDataRepository()
    let restApi: RestApi = RestApiImpl.sharedInstance
    let restApiImpl: RestApiImpl = RestApiImpl.sharedInstance
    
    public func getMoviesDetail(movieId: String, language: String) -> RxSwift.Observable<MovieDetailEntiy> {
        return restApiImpl.request(ApiRouter.getMoviesDetail(movieId: movieId, language: language))
    }
    
    public func getMovies(listId: String, language: String) -> Observable<MoviesEntity.Movies> {
        return restApiImpl.request(ApiRouter.getMovies(listId: listId, language: language))
    }
    
    public func getVideosMovie(movieId: String, language: String) -> Observable<VideosEntity.Videos> {
        return restApiImpl.request(ApiRouter.getVideosMovie(movieId: movieId, language: language))
    }
}
