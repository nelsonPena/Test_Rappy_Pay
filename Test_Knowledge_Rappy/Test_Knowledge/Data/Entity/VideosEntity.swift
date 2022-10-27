//
//  VideosEntity.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 26/10/22.
//

import Foundation

public enum VideosEntity{
    public struct Results: Decodable {
        let key: String
        let site: String
        func mapper() -> VideosModel.Results {
            .init(key: self.key, site: self.site)
        }
    }
    
    public struct Videos: Decodable {
        let results: [Results]
        
        func mapper() -> VideosModel.Videos {
            .init(results: self.results.map{$0.mapper()})
        }
    }
}
