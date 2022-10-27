//
//  ServiceDataRepository.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 22/10/22.
//

import Foundation
@_exported import class RxSwift.Observable

public protocol ServiceRepository {
    func getMovies(listId: String, language: String) -> Observable<MoviesEntity.Movies>
    func getMoviesDetail(movieId: String, language: String) -> Observable<MovieDetailEntiy>
    func getVideosMovie(movieId: String, language: String) -> Observable<VideosEntity.Videos> 
}
