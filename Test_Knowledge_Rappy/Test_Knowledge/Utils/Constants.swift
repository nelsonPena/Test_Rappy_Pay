//
//  Constants.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 22/10/22.
//

import Foundation

struct Constants {
    
    //The API's base URL
    static let baseUrl = "https://api.themoviedb.org"
    static let baseUrlImage = "https://image.tmdb.org/t/p/w500"
    static let apiKey = "aeee4eb56eab2530458d9a85b43bae49"
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let listId = "userId"
        static let imageName = "imageName"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
}
