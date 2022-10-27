//
//  HomeRouter.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import UIKit

protocol HomeRouterProtocol {
    func routeToMovieDetail(movieId: String, language: String)
}

public class HomeRouter {
   
    var currentViewController: UIViewController?
    
    public init(currentViewController: UIViewController) {
        self.currentViewController = currentViewController
    }
}

extension HomeRouter: HomeRouterProtocol {
    func routeToMovieDetail(movieId: String, language: String) {
        let movieDetailViewData = MovieDetailViewData(movieId: movieId, language: language)
        let moviewDetailViewController = MoviewDetailViewController.build(movieDetailViewData: movieDetailViewData)
        guard let navigationController = currentViewController?.navigationController else {
            return
        }
        navigationController.pushViewController(moviewDetailViewController, animated: true)
    }
    
}
