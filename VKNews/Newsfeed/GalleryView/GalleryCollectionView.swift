//
//  GalleryCollectionView.swift
//  VKNews
//
//  Created by Rail on 16.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photos = [FeedCellPhotoAttachmentViewModel]()
    
    init() {
        //        Расположение объектов в коллекшен вью
        let layout = UICollectionViewFlowLayout()
        //        Добавление объектов внутри коллекции будет сверху вниз
        layout.scrollDirection = .horizontal
//        Даём нашему инициализатору границы
        super.init(frame: .zero, collectionViewLayout: layout)
//        Подписываемся под протоколы
        delegate = self
        dataSource = self
        
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        Регистрируем ячейку
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }
    //    Получает массив с фото и пердаёт в наш массив photos в контроллере
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
//        Перезагружаем ячейку
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        Создаём ячейку
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
        
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
