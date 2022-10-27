//
//  NewContentCell.swift
//  DiffableDataSource
//
//  Created by James Rochabrun on 8/4/19.
//  Copyright © 2019 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MovieCell: BaseCollectionViewCell<MoviesModel.Results> {
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func sharedInit() {
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    override func configureCell(with item: MoviesModel.Results) {
        if item.posterBase64Encoded.isEmpty {
            imageView.downloaded(from: Constants.baseUrlImage + item.posterPath)
        }else{
            imageView.imageFromBase64EncodedString(base64Encoded: item.posterBase64Encoded)
        }
       
    }
}

