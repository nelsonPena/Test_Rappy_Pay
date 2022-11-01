//
//  File.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 22/10/22.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    case getMovies(listId: String, language: String)
    case getMoviesDetail(movieId: String, language: String)
    case getVideosMovie(movieId: String, language: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getMovies:
            return .get
        case .getMoviesDetail:
            return .get
        case .getVideosMovie:
            return .get
        }
    }
    
    //MARK: - Path
    private var baseUrl: String {
        switch self {
        case .getMovies(let listId, _):
            return (Constants.baseUrl + "/4/list/{listNumber}").replacingOccurrences(of: "{listNumber}", with: listId)
        case .getMoviesDetail(let movieId, _):
            return (Constants.baseUrl + "/3/movie/{movieId}").replacingOccurrences(of: "{movieId}", with: movieId)
        case .getVideosMovie(movieId: let movieId, language: _):
            return (Constants.baseUrl + "/3/movie/{movieId}/videos").replacingOccurrences(of: "{movieId}", with: movieId)
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getMovies(_, let language),.getMoviesDetail(_, let language),.getVideosMovie(_, let language):
            return ["api_key": Constants.apiKey,
                    "language": language]
        }
    }
}
