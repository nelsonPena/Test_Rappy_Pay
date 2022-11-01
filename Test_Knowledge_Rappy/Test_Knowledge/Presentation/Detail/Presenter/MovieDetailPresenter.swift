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
    func getKeyVideo() -> String
}

public class MovieDetailPresenter {
    internal unowned let view: MoviewDetailViewControllerProtocol
    private let movieDetailViewData: MovieDetailViewData
    internal let interactor: MovieDetailInteractorProtocol
    private let disposeBag = DisposeBag()
    private var movieDetail = MovieDetailModel()
    private var videosMovie = VideosModel.Videos()
    
    init (view: MoviewDetailViewControllerProtocol,
          movieDetailViewData: MovieDetailViewData,
          interactor: MovieDetailInteractorProtocol) {
        self.view = view
        self.movieDetailViewData = movieDetailViewData
        self.interactor = interactor
    }
}

extension MovieDetailPresenter: MovieDetailPresenterProtocol {
    func getKeyVideo() -> String {
        if let results = videosMovie.results, results.count > 0  {
            return results[0].key
        }else{ return "" }
    }
    
    func viewDidLoad() {
        let callGetVideos: () -> Void = {
            self.getVideos()
        }
        getDetail(onNextHandler: callGetVideos)
    }
    
    func getMovieDetail() -> MovieDetailModel {
        movieDetail
    }
}

extension MovieDetailPresenter {
    
    func getDetail(onNextHandler: (()->())? = nil)  {
        view.displayLoader()
        interactor.getMovieDetailServer(of: movieDetailViewData.movieId, language: movieDetailViewData.language).observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieDetail  in
                self?.setMovieDetail(detail: movieDetail)
            }, onError: { error in
                switch error {
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            },onCompleted: {
                guard let handler = onNextHandler else {
                    return
                }
                handler()
            })
            .disposed(by: disposeBag)
    }
    
    func displayAllInformation(detail movieDetail: MovieDetailModel){
        self.view.displayDetailData(viewModel: DisplayDetail.ViewModelDetail(movieDetail: movieDetail))
        self.displayReleaseDate(movieDetail: movieDetail)
        self.displayVoteAverage(movieDetail: movieDetail)
        self.displayBackgroundImage(movieDetail: movieDetail)
    }
    
    func getVideos()  {
        interactor.getVideosMovie(of: movieDetailViewData.movieId, language: movieDetailViewData.language).observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] videosMovie in
                self?.setVideosMovie(videos: videosMovie)
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
                DispatchQueue.main.async {
                    guard let detail = self?.movieDetail else {
                        return
                    }
                    self?.displayAllInformation(detail: detail)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func displayVoteAverage(movieDetail: MovieDetailModel){
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        view.displayVoteAverage(viewModel: DisplayDetail.ViewModelVoteAverage(voteAverage: formatter.string(for: movieDetail.voteAverage) ?? "?"))
    }
    
    private func displayReleaseDate(movieDetail: MovieDetailModel){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        let yearString = dateFormatter.string(from: movieDetail.releaseDate.toDate())
        view.displayReleaseDate(viewModel: DisplayDetail.ViewModelReleaseDate(year: yearString))
    }
    
    func displayBackgroundImage(movieDetail: MovieDetailModel){
        interactor.downloadBackgroundImage(posterPath: movieDetail.posterPath) { [weak self] data in
            guard let image = UIImage(data: Data(base64Encoded: data, options: Data.Base64DecodingOptions(rawValue: 0))!) else {
                return
            }
            DispatchQueue.main.async {
                self?.view.displayImageBackground(viewModel: DisplayDetail.ViewModelImageBackground(image: image))
                self?.view.hideLoader()
            }
        }
    }
    
    func setMovieDetail(detail movieDetailModel: MovieDetailModel){
        self.movieDetail = movieDetailModel
    }
    
    func setVideosMovie(videos: VideosModel.Videos){
        self.videosMovie = videos
    }
}
