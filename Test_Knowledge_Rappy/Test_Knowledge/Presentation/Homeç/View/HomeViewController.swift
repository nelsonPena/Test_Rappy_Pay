//
//  ViewController.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import UIKit
protocol HomeViewControllerProtocol: AnyObject  {
    func displayCollectionViewMovies()
    func displayAlertNoHasNetworkConnection()
}

extension HomeViewController {
    static func build() -> UIViewController {
        let homeViewController = HomeViewController.instantiate()
        let router = HomeRouter(currentViewController: homeViewController)
        let presenter = HomePresenter(view: homeViewController, router: router)
        homeViewController.presenter = presenter
        return homeViewController
    }
}

class HomeViewController: UIViewController, Storyboarded {
    
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section<Header, [MoviesModel.Results]>, MoviesModel.Results>?
    var recommendedMoviesSnapshot: NSDiffableDataSourceSnapshot<SectionRecommendedMovies<[MoviesModel.Results]>, MoviesModel.Results>?
    internal var presenter: HomePresenter?
    let scrollView = UIScrollView()
    let contentView = UIView()
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    var isEs = false
    
    lazy var recommendedMoviesCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: createLayoutRecommendeMovies())
        collectionView.backgroundColor = UIColor.black
        collectionView.register(MovieCell.self)
        collectionView.tag = Int(MovieType.recommendedMovies.rawValue)
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    public lazy var generalMoviesCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: createLayoutGeneralMovies())
        collectionView.backgroundColor = UIColor.black
        collectionView.register(MovieCell.self)
        collectionView.delegate = self
        collectionView.tag = Int(MovieType.topRantedMovies.rawValue)
        collectionView.isScrollEnabled = false
        collectionView.registerHeader(TitleSectionTypes.self, kind: UICollectionView.elementKindSectionHeader)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var generalMoviesDataSource: UICollectionViewDiffableDataSource<Section<Header, [MoviesModel.Results]>, MoviesModel.Results> = {
        let  dataSource = UICollectionViewDiffableDataSource<Section<Header, [MoviesModel.Results]>, MoviesModel.Results>.init(collectionView: generalMoviesCollectionView, cellProvider: { collectionView, indexPath, movie  in
            let cell: MovieCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(with: movie)
            return cell
        })
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            let header: TitleSectionTypes = collectionView.dequeueSuplementaryView(of: UICollectionView.elementKindSectionHeader, at: indexPath)
            if let section = self.currentSnapshot?.sectionIdentifiers[indexPath.section] {
                header.label.text = "\(section.headerItem.titleHeader)"
            }
            return header
        }
        return dataSource
    }()
    
    lazy var recommendedMoviesDataSource: UICollectionViewDiffableDataSource<SectionRecommendedMovies<[MoviesModel.Results]>, MoviesModel.Results> = {
        let  dataSource = UICollectionViewDiffableDataSource<SectionRecommendedMovies<[MoviesModel.Results]>, MoviesModel.Results>.init(collectionView: recommendedMoviesCollectionView, cellProvider: { collectionView, indexPath, movie  in
            let cell: MovieCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(with: movie)
            return cell
        })
        return dataSource
    }()
    
    lazy var generalMoviesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "Recomendados para ti"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var filterByDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lanzados hasta 2011", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onFilterByDate), for: .touchUpInside)
        return button
    }()
    
    lazy var filterByLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("En español", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onFilterByLanguaje), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setup()
        self.view.backgroundColor = .black
    }
    
    func setupNavigation()  {
        self.navigationItem.title = "eMovie"
    }
    
    func setup() {
        setupViews()
        setupNavigation()
    }
    
    func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.addArrangedSubview(filterByDateButton)
        buttonsStackView.addArrangedSubview(filterByLanguageButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(generalMoviesLabel)
        contentView.addSubview(generalMoviesCollectionView)
        contentView.addSubview(recommendedMoviesCollectionView)
        contentView.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            generalMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            generalMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            generalMoviesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            generalMoviesCollectionView.heightAnchor.constraint(equalToConstant: 450),
            recommendedMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendedMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendedMoviesCollectionView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            recommendedMoviesCollectionView.heightAnchor.constraint(equalToConstant: 800),
            recommendedMoviesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            generalMoviesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            generalMoviesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            generalMoviesLabel.topAnchor.constraint(equalTo: generalMoviesCollectionView.bottomAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            buttonsStackView.topAnchor.constraint(equalTo: generalMoviesLabel.bottomAnchor, constant: 10),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    @objc func onFilterByDate(sender: UIButton!) {
        if sender.backgroundColor == .black {
            presenter?.loadRecommendedMoviesFilterByDate()
        }else{
            presenter?.restoreRecommendedMovies()
        }
        sender.backgroundColor = sender.backgroundColor == .black ? .white : .black
        sender.setTitleColor(sender.titleLabel?.textColor == .black ? .white : .black, for: .normal)
    }
    
    @objc func onFilterByLanguaje(sender: UIButton!) {
        if sender.backgroundColor == .black {
            presenter?.loadRecommendedMoviesFilterByLanguage()
        }else{
            presenter?.restoreRecommendedMovies()
        }
        sender.backgroundColor = sender.backgroundColor == .black ? .white : .black
        sender.setTitleColor(sender.titleLabel?.textColor == .black ? .white : .black, for: .normal)
        isEs = sender.backgroundColor == .white
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func displayCollectionViewMovies() {
        loadSnapshotRecommendeMovies()
        loadSnapshotGeneralMovies()
    }
    
    func displayAlertNoHasNetworkConnection() {
        let alert = UIAlertController(title: "No se pueden obtener registros", message: "Parece que no tienes conexión a Internet", preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == MovieType.recommendedMovies.rawValue {
            if let movie = recommendedMoviesDataSource.itemIdentifier(for: indexPath) {
                presenter?.didTapMovie(movieId: movie.id, language: isEs ? "es" : "en")
            }
        }else{
            if let movie = generalMoviesDataSource.itemIdentifier(for: indexPath) {
                presenter?.didTapMovie(movieId: movie.id, language: movie.originalLanguage)
            }
        }
    }
}
