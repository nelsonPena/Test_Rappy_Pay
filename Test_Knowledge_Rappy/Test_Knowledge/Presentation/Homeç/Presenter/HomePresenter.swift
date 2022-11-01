//
//  PresenterHomeViewController.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import Foundation
import UIKit
import RxSwift

protocol HomePresenterProtocol: AnyObject {
    var upcomingMovies: MoviesModel.Movies? { get set }
    var topRantedMovies: MoviesModel.Movies? { get set }
    var recommendedMovies: MoviesModel.Movies? { get set }
    func loadRecommendedMoviesFilterByDate()
    func loadRecommendedMoviesFilterByLanguage()
    func restoreRecommendedMovies()
    func didTapMovie(movieId: Int64, language: String)
    func viewDidLoad()
}

public class HomePresenter {
    internal let router: HomeRouterProtocol
    internal unowned let view: HomeViewControllerProtocol
    internal let interactor: HomeInteractorProtocol
    private let disposeBag = DisposeBag()
    var upcomingMovies: MoviesModel.Movies?
    var topRantedMovies: MoviesModel.Movies?
    var recommendedMovies: MoviesModel.Movies?
    private var upcomingMoviesResults: [MoviesModel.Results] = []
    private var topRantedMoviesResults: [MoviesModel.Results] = []
    
    init (view: HomeViewControllerProtocol,
          router: HomeRouterProtocol,
          interactor: HomeInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    func didTapMovie(movieId: Int64, language: String) {
        router.routeToMovieDetail(movieId: String(movieId), language: language)
    }
    
    func viewDidLoad() {
        if interactor.containsRecordsInFetchRequest() {
            getMoviesListChache()
        }else{
            loadMoviesListDataServer(language: "en")
        }
    }
    
    func loadMoviesListDataServer(language: String) {
        if !RestApiImpl.sharedInstance.hasNetworkConnection() {
            view.displayAlertNoHasNetworkConnection()
            return
        }
        
        let callUpcoming: () -> Void = {
            self.getUpcoming(language: language)
        }
        getTopRated(onNextHandler: callUpcoming, language: language)
    }
    
    func getMoviesListChache()  {
        let movies = interactor.listAllMoviesFetchRequest()
        movies.forEach { movie in
            if movie.type == MovieType.upcomingMovies.rawValue {
                upcomingMoviesResults.append(MoviesModel.Results(id: movie.movieId,
                                                                 posterPath: movie.posterPath, posterBase64Encoded: movie.posterBase64Encoded, originalTitle: movie.originalTitle, originalLanguage: movie.originalLanguage, releaseDate: movie.releaseDate.toString()))
            }else{
                topRantedMoviesResults.append(MoviesModel.Results(id: movie.movieId,
                                                                  posterPath: movie.posterPath, posterBase64Encoded: movie.posterBase64Encoded, originalTitle: movie.originalTitle, originalLanguage: movie.originalLanguage, releaseDate: movie.releaseDate.toString()))
            }
        }
        upcomingMovies = MoviesModel.Movies(results: upcomingMoviesResults)
        topRantedMovies = MoviesModel.Movies(results: topRantedMoviesResults)
        recommendedMovies = MoviesModel.Movies(results: Array(topRantedMoviesResults.prefix(6)))
        self.view.displayCollectionViewMovies()
    }
    
    func loadRecommendedMoviesFilterByDate()  {
        let movies = interactor.listRecommendedMoviesFetchRequest(by: "2011-01-01".toDate())
        var recommendedMoviesResults: [MoviesModel.Results] = []
        movies.forEach { movie in
            recommendedMoviesResults.append(MoviesModel.Results(id: movie.movieId,
                                                                posterPath: movie.posterPath, posterBase64Encoded: movie.posterBase64Encoded, originalTitle: movie.originalTitle, originalLanguage: movie.originalLanguage, releaseDate: movie.releaseDate.toString()))
        }
        recommendedMovies = MoviesModel.Movies(results: recommendedMoviesResults)
        self.view.displayCollectionViewMovies()
    }
    
    func loadRecommendedMoviesFilterByLanguage()  {
        getSpanishMovies(language: "es")
    }
    
    func restoreRecommendedMovies(){
        recommendedMovies = topRantedMovies
        self.view.displayCollectionViewMovies()
    }
    
}

extension HomePresenter {
    func getTopRated(onNextHandler: (()->())? = nil, language: String) {
        _ = interactor.getListMoviesServer(by: "3", language: language)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { moviesList in
                self.topRantedMovies = moviesList
                self.recommendedMovies = MoviesModel.Movies(results: Array(moviesList.results.prefix(6)))
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
                guard let movies = self?.topRantedMovies else { return }
                self?.interactor.saveFilmsCoreData(movies: movies, movieType: .topRantedMovies)
                guard let handler = onNextHandler else {
                    return
                }
                handler()
            })
            .disposed(by: disposeBag)
    }
    
    func getSpanishMovies(language: String) {
        _ = interactor.getListMoviesServer(by: "3", language: language)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { moviesList in
                self.recommendedMovies = MoviesModel.Movies(results: Array(moviesList.results.prefix(6)))
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
                    self?.view.displayCollectionViewMovies()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getUpcoming(language: String) {
        _ = interactor.getListMoviesServer(by: "1", language: language)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { moviesList in
                self.upcomingMovies = moviesList
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
                guard let movies = self?.upcomingMovies else { return }
                self?.interactor.saveFilmsCoreData(movies: movies, movieType: .upcomingMovies)
                DispatchQueue.main.async {
                    self?.view.displayCollectionViewMovies()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}

