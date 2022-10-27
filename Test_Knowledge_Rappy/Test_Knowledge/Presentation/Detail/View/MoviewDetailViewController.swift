//
//  MoviewDetailViewController.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 25/10/22.
//

import UIKit
import Lottie

extension MoviewDetailViewController {
    static func build(movieDetailViewData: MovieDetailViewData) -> UIViewController {
        let moviewDetailViewController = MoviewDetailViewController.instantiate()
        let presenter = MovieDetailPresenter(
            view: moviewDetailViewController,
            movieDetailViewData: movieDetailViewData
        )
        moviewDetailViewController.presenter = presenter
        return moviewDetailViewController
    }
}

protocol MoviewDetailViewControllerProtocol: AnyObject  {
    func loadMovieDetailData(movieDetail: MovieDetailModel)
    func displayLoader()
    func hideLoader()
}


class MoviewDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var overviewTittleLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var seeTrailerButton: UIButton!
   
    internal var presenter: MovieDetailPresenter?
    var animationView = LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setup()
    }
    
    func setup()  {
        view1.layer.cornerRadius = 4
        view2.layer.cornerRadius = 4
        view3.layer.cornerRadius = 4
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        setupBackButton()
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = false
        seeTrailerButton.layer.borderColor = UIColor.white.cgColor
        seeTrailerButton.layer.borderWidth = 1
        seeTrailerButton.layer.cornerRadius = 5
        seeTrailerButton.setTitle("Ver trailer", for: .normal)
        seeTrailerButton.addTarget(self, action: #selector(showTrailerAction), for: .touchUpInside)
    }
    
    func setupBackButton()  {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        backButton.tintColor = .white
        backButton.setImage(UIImage.init(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(sender: UIButton) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    @objc func showTrailerAction(sender: UIButton) {
        guard let results = presenter?.getVideosMovies().results else {
            return
        }
        if results.count > 0 {
            let trailerController = TrailerViewController.build()
            trailerController.modalPresentationStyle = .popover
            trailerController.keyVideo = results[0].key
            navigationController?.present(trailerController, animated: true)
        }
    }
    
}

extension MoviewDetailViewController: MoviewDetailViewControllerProtocol {
    func displayLoader() {
        effectView.isHidden = false
        animationView = loaderView.displayLoader()
    }
    
    func hideLoader() {
        effectView.isHidden = true
        loaderView.hideLoader(animationView: animationView)
    }
    
   
    func loadMovieDetailData(movieDetail: MovieDetailModel) {
        tittleLabel.text = movieDetail.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        let yearString = dateFormatter.string(from: movieDetail.releaseDate.toDate())
        yearLabel.text = yearString
        languageLabel.text = movieDetail.originalLanguage
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        averageLabel.text = formatter.string(for: movieDetail.voteAverage) ?? "?"
        taglineLabel.text = movieDetail.tagline
        overviewLabel.text = movieDetail.overview
        self.imageBackground.downloaded(from: (Constants.baseUrlImage + movieDetail.posterPath), useLoading: false)
    }
    
}
