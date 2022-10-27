//
//  HomeViewController+CollectionView.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 22/10/22.
//

import UIKit

extension HomeViewController {
    func createLayoutRecommendeMovies() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.48),
                                              heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func loadSnapshotRecommendeMovies()  {
        var sectionItems = [SectionRecommendedMovies<[MoviesModel.Results]>]()
        guard let recommendedMovies = self.presenter?.recommendedMovies?.results else { return }
        sectionItems.append(SectionRecommendedMovies(items: recommendedMovies))
        let payloadDatasource = DataSource(sections: sectionItems)
        recommendedMoviesSnapshot = NSDiffableDataSourceSnapshot<SectionRecommendedMovies<[MoviesModel.Results]>, MoviesModel.Results>()
        payloadDatasource.sections.forEach {
            recommendedMoviesSnapshot?.appendSections([$0])
            recommendedMoviesSnapshot?.appendItems($0.items)
        }
        guard let snapShot = recommendedMoviesSnapshot else { return }
        recommendedMoviesDataSource.apply(snapShot, animatingDifferences: true)
    }
}


