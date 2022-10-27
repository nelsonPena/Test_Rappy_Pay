//
//  ZemogaMobileHTTPClientTest.swift
//  ZemogaMobileTests
//
//  Created by Nelson Peña on 31/05/22.
//

import Foundation
@testable import Test_Knowledge

/**
 MockHTTPClientTest
 Esta clase es una copia o Mock del servicio de consumo rest  donde se implementa el protocolo `HTTPClientProtocol` implementado en la clase  `HttpClient`
 
 - important: Acá se recibe un nombre de archivo para localizar el JSON que nos va a servir como simulador de respuesta del servicio`.
 */
final class MockRestApi: ServiceRepository, Mockable {
    
    func getMovies(listId: String, language: String) -> RxSwift.Observable<MoviesEntity.Movies> {
        return loadJSON(filename: filename)
    }
    
    func getMoviesDetail(movieId: String, language: String) -> RxSwift.Observable<MovieDetailEntiy> {
        return loadJSON(filename: filename)
    }
    
    func getVideosMovie(movieId: String, language: String) -> RxSwift.Observable<VideosEntity.Videos> {
       return loadJSON(filename: filename)
    }
    
    var bunble: Bundle
    var filename: String
    
    init(filename: String) {
        self.filename = filename
        self.bunble = Bundle(for: type(of: self))
    }

}
