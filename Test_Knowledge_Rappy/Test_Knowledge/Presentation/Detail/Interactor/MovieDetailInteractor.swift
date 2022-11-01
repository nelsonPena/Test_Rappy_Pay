//
//  MovieDetailInteractor.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 25/10/22.
//

import Foundation

//
//  MovieDetailInteractor.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import Foundation
import CoreData


public protocol MovieDetailInteractorProtocol {
    func getMovieDetailServer(of movieId: String, language: String) -> Observable<MovieDetailModel>
    func getVideosMovie(of movieId: String, language: String) -> RxSwift.Observable<VideosModel.Videos>
    func downloadBackgroundImage(posterPath: String,_ completion: @escaping (String) -> Void)
}

public class MovieDetailInteractor: Interactor {
   
    public override init(repository: Any) {
        super.init(repository: repository)
    }
}

extension MovieDetailInteractor: MovieDetailInteractorProtocol{
    public func downloadBackgroundImage(posterPath: String,_ completion: @escaping (String) -> Void){
        DownloadImage.downloaded(from: posterPath) { data in
            return completion(data)
        }
    }
    
    public func getMovieDetailServer(of movieId: String, language: String) -> RxSwift.Observable<MovieDetailModel> {
        return (repository as! ServiceRepository).getMoviesDetail(movieId: movieId, language: language).map{$0.mapper()}
    }
    
    public func getVideosMovie(of movieId: String, language: String) -> RxSwift.Observable<VideosModel.Videos> {
        return (repository as! ServiceRepository).getVideosMovie(movieId: movieId, language: language).map{$0.mapper()}
    }
    
    
}
