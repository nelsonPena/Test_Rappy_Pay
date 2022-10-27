//
//  ResApi.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//


import UIKit
import RxSwift
import Alamofire

protocol RestApi {
    func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T>
}
