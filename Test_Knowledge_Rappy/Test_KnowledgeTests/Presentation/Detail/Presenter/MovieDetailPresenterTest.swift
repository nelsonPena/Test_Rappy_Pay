//
//  MovieDetailPresenterTest.swift
//  Test_KnowledgeTests
//
//  Created by Nelson Peña on 1/11/22.
//

import XCTest
import RxSwift
@testable import Test_Knowledge

final class MovieDetailPresenterTest: XCTestCase {
    var sut: MovieDetailPresenter!
    var window: UIWindow!
    var moviewDetailViewController = MoviewDetailViewController()
    let interactor = InteractorDetailViewControllerTest(filename: "MovieDetail")
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupMovieDetailPresenter()
    }
    
    func setupMovieDetailPresenter()
    {
        moviewDetailViewController = MoviewDetailViewController.instantiate()
        let movieDetailViewData = MovieDetailViewData(movieId: "287947", language: "en")
        let movieDetailInteractor = MovieDetailInteractor(repository: ServiceDataRepository.sharedInstance)
        sut = MovieDetailPresenter(
            view: moviewDetailViewController,
            movieDetailViewData: movieDetailViewData,
            interactor: movieDetailInteractor
        )
    }
    
    
    func loadView()
    {
        window.addSubview(moviewDetailViewController.view)
        RunLoop.current.run(until: Date())
    }
    
    
    func testShowTrailerMovie()
    {
        loadView()
        let disposeBag = DisposeBag()
        interactor.getVideosMovie(of: "", language: "")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] videosList in
                self?.sut.setVideosMovie(videos: videosList)
                XCTAssertEqual(self?.sut.getKeyVideo(), "kEhmx28Tbek", "when you want to get the key the video must contain a parameter other than empty")
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
    
    func testPresentDetailMovie()
    {
        loadView()
        let disposeBag = DisposeBag()
        interactor.getMovieDetailServer(of: "", language: "")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                self?.sut.displayAllInformation(detail: detail)
                XCTAssertEqual(self?.moviewDetailViewController.tittleLabel.text, detail.title, "Displaying an moview detail should update the tittle label")
                XCTAssertEqual(self?.moviewDetailViewController.overviewLabel.text, detail.overview, "Displaying an moview detail should update the overview label")
                XCTAssertEqual(self?.moviewDetailViewController.taglineLabel.text, detail.tagline, "Displaying an moview detail should update the tagline label")
                XCTAssertEqual(self?.moviewDetailViewController.yearLabel.text, "19", "Displaying an moview detail should update the year label")
                XCTAssertEqual(self?.moviewDetailViewController.averageLabel.text, "7.05", "Displaying an vote average should update the average label")
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
    
    func testPresentBackgroundImage(){
        loadView()
        interactor.downloadBackgroundImage(posterPath: "") { [weak self] data in
            guard let image = UIImage(data: Data(base64Encoded: data, options: Data.Base64DecodingOptions(rawValue: 0))!) else {
                return
            }
            let originalData = image.pngData()
            self?.moviewDetailViewController.displayImageBackground(viewModel: DisplayDetail.ViewModelImageBackground(image: image))
            XCTAssertEqual(self?.moviewDetailViewController.imageBackground.image?.pngData(), originalData, "Displaying an background image should update the imageview")
        }
    }
}
