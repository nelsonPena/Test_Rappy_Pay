//
//  MovieDetailModel.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 25/10/22.
//

import Foundation

public struct MovieDetailModel {
    let originalLanguage: String
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: String
    let tagline: String
    let voteAverage: Decimal
    
    init(originalLanguage: String = "", title: String = "", overview: String = "", posterPath: String = "", releaseDate: String = "", tagline: String = "", voteAverage: Decimal = 0) {
        self.originalLanguage = originalLanguage
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.tagline = tagline
        self.voteAverage = voteAverage
    }
}
