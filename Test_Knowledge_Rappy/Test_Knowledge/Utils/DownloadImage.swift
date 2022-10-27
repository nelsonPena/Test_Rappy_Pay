//
//  DownloadImage.swift
//  Test_Knowledge
//
//  Created by Nelson Geovanny Pena Agudelo on 23/10/22.
//

import Foundation

class DownloadImage{
    class func downloaded(from link: String,_ completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + link) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else { return }
            completion(data.base64EncodedString())
        }.resume()
    }

}
