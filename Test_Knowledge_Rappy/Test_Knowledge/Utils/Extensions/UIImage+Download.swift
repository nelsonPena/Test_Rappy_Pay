//
//  Color+Name.swift
//  Findme
//
//  Created by Nelson Peña on 15/09/21.
//

import UIKit
import Lottie

extension UIImageView {
    func downloaded(from url: URL, useLoading: Bool) {
        let animationView = LottieAnimationView(name: "image_loader")
        animationView.loopMode = .loop
        if useLoading {
            DispatchQueue.main.async() { [weak self] in
                animationView.frame = self!.bounds
                self?.addSubview(animationView)
                animationView.play()
            }
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                if useLoading {
                    animationView.stop()
                    animationView.removeFromSuperview()
                }
            }
        }.resume()
    }
    
    func downloaded(from link: String, useLoading: Bool = true) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, useLoading: useLoading)
    }
    
    func imageFromBase64EncodedString(base64Encoded: String){
        self.image = UIImage(data: Data(base64Encoded: base64Encoded, options: Data.Base64DecodingOptions(rawValue: 0))!)
    }
}

extension UIView {
    func displayLoader() ->  LottieAnimationView {
        let animationView = LottieAnimationView(name: "image_loader")
        animationView.loopMode = .loop
        DispatchQueue.main.async() { [weak self] in
            animationView.frame = self!.bounds
            self?.addSubview(animationView)
            animationView.play()
        }
        return animationView
    }
    
    func hideLoader(animationView: LottieAnimationView)  {
        DispatchQueue.main.async() { [weak self] in
            animationView.stop()
            animationView.removeFromSuperview()
        }
    }
}
