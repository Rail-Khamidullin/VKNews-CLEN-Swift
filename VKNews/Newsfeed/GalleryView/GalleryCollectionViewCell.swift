//
//  GalleryCollectionViewCell.swift
//  VKNews
//
//  Created by Rail on 16.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Настройка отображения ячейки
class GalleryCollectionViewCell: UICollectionViewCell {
    
    //    Идентификатор ячейки
    static let reuseId = "GalleryCollectioViewCell"
    
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        Натуральное соотношение сторон изображения
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    //    Все корректировки интерфейса желательно делать в данном методе
    override func layoutSubviews() {
        
        //        Изображение будет обрезано до границ
        myImageView.layer.masksToBounds = true
        //        Скругление углов изображения
        myImageView.layer.cornerRadius = 10
        //        Добавляем тени
        self.layer.shadowRadius = 3
        //        Непрозрачность тени
        layer.shadowOpacity = 0.4
        //        Смещение тени
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
