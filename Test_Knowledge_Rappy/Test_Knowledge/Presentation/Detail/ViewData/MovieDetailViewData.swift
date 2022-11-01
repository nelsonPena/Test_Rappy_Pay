//
//  MovieDetailViewData.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 25/10/22.
//

import UIKit

public struct MovieDetailViewData {
    public let movieId: String
    public let language: String
}

enum DisplayDetail {
    public struct ViewModelVoteAverage {
        var voteAverage: String
    }
    public struct ViewModelReleaseDate{
        var year: String
    }
    public struct ViewModelDetail{
        var movieDetail: MovieDetailModel
    }
    public struct ViewModelImageBackground{
        var image: UIImage
    }
}

