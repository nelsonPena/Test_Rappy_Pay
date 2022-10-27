//
//  RestApiImpl.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//


import UIKit
import RxSwift
import Alamofire
import Reachability

public class RestApiImpl: RestApi {
    
    public static let sharedInstance = RestApiImpl()
    func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func hasNetworkConnection() -> Bool {
        let reachability = try! Reachability()
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        return !(reachability.connection == .unavailable)
    }
}

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case internalServerError    //Status code 500
}
