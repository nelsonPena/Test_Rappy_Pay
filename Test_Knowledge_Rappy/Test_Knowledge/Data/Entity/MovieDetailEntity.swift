//
//  MovieDetailEntity.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 25/10/22.
//

import Foundation

public struct MovieDetailEntiy: Decodable {
    let original_language: String
    let title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let tagline: String
    let vote_average: Decimal
    func mapper() -> MovieDetailModel {
        .init(originalLanguage: self.original_language, title: self.title, overview: self.overview, posterPath: self.poster_path, releaseDate: self.release_date, tagline: self.tagline, voteAverage: self.vote_average)
    }
}
