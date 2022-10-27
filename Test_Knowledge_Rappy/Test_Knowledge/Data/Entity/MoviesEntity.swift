//
//  MovieEntity.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import Foundation

public enum MoviesEntity{
    public struct Results: Decodable {
        let poster_path: String
        let original_title: String
        let original_language: String
        let release_date: String
        let id: Int
        func mapper() -> MoviesModel.Results {
            .init(id: Int64(self.id), posterPath: self.poster_path, originalTitle: self.original_title, originalLanguage: self.original_language, releaseDate: self.release_date)
        }
    }
    
    public struct Movies: Decodable {
        let results: [Results]
        
        func mapper() -> MoviesModel.Movies {
            .init(results: self.results.map{$0.mapper()})
        }
    }
}
