//
//  GalleryCollectionViewCell.swift
//  VKNews
//
//  Created by Rail on 16.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    //    Идентификатор ячейки
    static let reuseId = "GalleryCollectioViewCell"
    
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        Натуральное соотношение сторон изображения
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        //        Добавляем myImageView в ячейку
        addSubview(myImageView)
        
        //        Добавляем констрейнты для myImageView (будет заполнять всё пространство ячейки)
        myImageView.fillSuperview()
    }
    
    //    Для переиспользования ячейки
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    //    Будет принимать ссылку для скачивания картинки
    func set(imageUrl: String?) {
        myImageView.set(imageUrl: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
