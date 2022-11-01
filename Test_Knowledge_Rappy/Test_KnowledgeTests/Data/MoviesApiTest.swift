//
//  Test_KnowledgeTests.swift
//  Test_KnowledgeTests
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import XCTest
import RxSwift
@testable import Test_Knowledge

final class MoviesApiTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // En esta prueba unitaria se ejecuta el listado de publicaciones inicial, simulando un servidor de Internet local, leyendo un archivo JSON previamente cargado con la estructura exacta a la del consumo.
    func testMovieList() async throws  {
        let disposeBag = DisposeBag()
        ServiceDataRepositoryTest(filename: "MoviesList")
            .getMovies(listId: "", language: "")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { moviesList in
                XCTAssertTrue(moviesList.results.count > 0)
            }, onError: { error in
                switch error {
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func testMovieDetail() async throws  {
        let disposeBag = DisposeBag()
        ServiceDataRepositoryTest(filename: "MovieDetail")
            .getMoviesDetail(movieId: "", language: "")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { moviesList in
                XCTAssertTrue(!moviesList.title.isEmpty)
            }, onError: { error in
                switch error {
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func testMovieVideoList() async throws  {
        let disposeBag = DisposeBag()
        ServiceDataRepositoryTest(filename: "MoviesVideosList")
            .getVideosMovie(movieId: "", language: "")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { videosList in
                XCTAssertTrue(videosList.results.count > 0)
            }, onError: { error in
                switch error {
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    //MARK: MovieDetailPresenter
    
    
    
}
