//
//  HomeViewController+CollectionView.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 22/10/22.
//

import UIKit

extension HomeViewController {
    
    func createLayoutGeneralMovies() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400),
                                               heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind:  UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func loadSnapshotGeneralMovies()  {
        var sectionItems = [Section<Header, [MoviesModel.Results]>]()
        guard let upcomingMovies = self.presenter?.upcomingMovies?.results else { return }
        guard let topRantedMovies = self.presenter?.topRantedMovies?.results else { return }
        sectionItems.append(Section(headerItem: Header(titleHeader: "Próximos estrenos"), items: upcomingMovies))
        sectionItems.append(Section(headerItem: Header(titleHeader: "Tendencia"), items: topRantedMovies))
        let payloadDatasource = DataSource(sections: sectionItems)
        currentSnapshot = NSDiffableDataSourceSnapshot<Section<Header, [MoviesModel.Results]>, MoviesModel.Results>()
        payloadDatasource.sections.forEach {
            currentSnapshot?.appendSections([$0])
            currentSnapshot?.appendItems($0.items)
        }
        guard let snapShot = currentSnapshot else { return }
       generalMoviesDataSource.apply(snapShot, animatingDifferences: true)
    }
}


