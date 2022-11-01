//
//  Mockable.swift
//  ZemogaMobileTests
//
//  Created by Nelson Peña on 31/05/22.
//

import Foundation
import RxSwift

protocol RestApiImplMockable: AnyObject {
    var bunble: Bundle { get }
    func loadJSON<T: Decodable>(filename: String) -> Observable<T>
    func loadImage(filename: String) -> String
}

extension RestApiImplMockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Decodable>(filename: String) -> Observable<T> {
        guard let path = bunble.url(forResource: filename, withExtension: "json") else {
            fatalError("failed to load JSON file.")
        }
        do {
            let data = try Data(contentsOf: path)
            let decodeObjet = try JSONDecoder().decode(T.self, from: data)
            return Observable<T>.create { observer in
                observer.onNext(decodeObjet)
                observer.onCompleted()
                return Disposables.create {
                }
            }
            
        }catch {
            print("❌ \(error)")
            fatalError("failed to decode JSON.")
        }
    }
    
    func loadImage(filename: String) -> String {
        guard let path = bunble.url(forResource: filename, withExtension: "jpeg") else {
            fatalError("failed to load image file.")
        }
        do {
            let data = try Data(contentsOf: path)
            let base64EncodedString = data.base64EncodedString()
            return base64EncodedString
        }catch {
            print("❌ \(error)")
            fatalError("failed to decode image.")
        }
    }
    
}
