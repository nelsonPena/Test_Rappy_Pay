//
//  MovieDetailPresenter.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 25/10/22.
//

import Foundation
import UIKit
import RxSwift

protocol MovieDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getMovieDetail() -> MovieDetailModel
    func getVideosMovies() -> VideosModel.Videos
}

public class MovieDetailPresenter {
    internal unowned let view: MoviewDetailViewControllerProtocol
    private let movieDetailViewData: MovieDetailViewData
    internal let interactor = MovieDetailInteractor(repository: ServiceDataRepository.sharedInstance)
    private let disposeBag = DisposeBag()
    private var movieDetail = MovieDetailModel()
    private var videosMovie = VideosModel.Videos()
    
    init (view: MoviewDetailViewControllerProtocol,
          movieDetailViewData: MovieDetailViewData) {
        self.view = view
        self.movieDetailViewData = movieDetailViewData
    }
}

extension MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    func viewDidLoad() {
        getDetail()
        getVideos()
    }
    
    func getMovieDetail() -> MovieDetailModel {
        movieDetail
    }
    
    func getVideosMovies() -> VideosModel.Videos {
        videosMovie
    }
    
}

extension MovieDetailPresenter {
    
    func getDetail()  {
        view.displayLoader()
        interactor.getMovieDetailServer(of: movieDetailViewData.movieId, language: movieDetailViewData.language).observe(on: MainScheduler.instance)
             .subscribe(onNext: { movieDetail in
                 self.movieDetail = movieDetail
             }, onError: { error in
                 switch error {
                 case ApiError.forbidden:
                     print("Forbidden error")
                 case ApiError.notFound:
                     print("Not found error")
                 default:
                     print("Unknown error:", error)
                 }
             },onCompleted: { [weak self] in
                 self?.view.hideLoader()
                 guard let detail = self?.movieDetail else {
                     return
                 }
                 self?.view.loadMovieDetailData(movieDetail: detail)
             })
             .disposed(by: disposeBag)
    }
    
    
    func getVideos()  {
        interactor.getVideosMovie(of: movieDetailViewData.movieId, language: movieDetailViewData.language).observe(on: MainScheduler.instance)
             .subscribe(onNext: { videosMovie in
                 self.videosMovie = videosMovie
             }, onError: { error in
                 switch error {
                 case ApiError.forbidden:
                     print("Forbidden error")
                 case ApiError.notFound:
                     print("Not found error")
                 default:
                     print("Unknown error:", error)
                 }
             },onCompleted: { [weak self] in
                 guard let detail = self?.movieDetail else {
                     return
                 }
                 self?.view.loadMovieDetailData(movieDetail: detail)
             })
             .disposed(by: disposeBag)
    }
}
