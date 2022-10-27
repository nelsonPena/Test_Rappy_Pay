//
//  VideosModel.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 26/10/22.
//

import Foundation

public enum VideosModel {
    public struct Results: Hashable  {
        public let key: String
        public let site: String
    }
    
    public struct Videos {
        public init(results: [Results] = []) {
            self.results = results
        }
        
        public let results: [Results]
    }
}
