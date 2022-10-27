//
//  Interactor.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 21/10/22.
//

import Foundation
import RxSwift

public class Interactor {

    let disposeBag = DisposeBag()
    var repository : Any
    
    public init(repository:Any){
        self.repository = repository
    }
}
