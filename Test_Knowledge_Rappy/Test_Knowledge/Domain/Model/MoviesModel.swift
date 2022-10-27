//
//  MoviesModel.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 22/10/22.
//

import Foundation

public enum MoviesModel {
    public struct Results: Hashable  {
        
        public init(id: Int64, posterPath: String, posterBase64Encoded: String = "", originalTitle: String, originalLanguage: String, releaseDate: String) {
            self.id = id
            self.posterPath = posterPath
            self.posterBase64Encoded = posterBase64Encoded
            self.originalTitle = originalTitle
            self.originalLanguage = originalLanguage
            self.releaseDate = releaseDate
        }
        
        public let id: Int64
        public let posterPath: String
        public let posterBase64Encoded: String
        public let originalTitle: String
        public let originalLanguage: String
        public let releaseDate: String
        public let identifier = UUID()
    }
    
    public struct Movies {
        public init(results: [Results] = []) {
            self.results = results
        }
        
        public let results: [Results]
    }
}

public enum MovieType: Int16 {
    case upcomingMovies = 1
    case topRantedMovies = 2
    case recommendedMovies = 3
}
