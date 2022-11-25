//
//  GalleryCollectionView.swift
//  VKNews
//
//  Created by Rail on 16.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //    Массив с изображениями
    var photos = [FeedCellPhotoAttachmentViewModel]()
    
    init() {
        //        Создаём объект класса с макетом границ нашего коллекшен вью
        let rowlayout = RowLayout()
        //        Даём нашему инициализатору границы
        super.init(frame: .zero, collectionViewLayout: rowlayout)
        //        Подписываемся под протоколы
        delegate = self
        dataSource = self
        //        Фон нашей галереи
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        Убираем индикатор скрола для коллекции
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        //        Регистрируем ячейку
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        //        Подписиываем экземпляр RowLayout под делегат
        if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
    }
    
    //    Получает массив с фото и передаёт в наш массив photos в контроллере
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        //        При переиспользование должно появляться первое изображение, а не какое-либо другое
        contentOffset = CGPoint.zero
        //        Перезагружаем ячейку
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        Кол-во изображений в секции
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        Создаём ячейку
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        //        Передаём ячейке данные
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
        //        Возвращаем ячейку
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GalleryCollectionView: RowlayoutDelegate {
    //    Заполняем обязательный метод делегата
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        //        Достаём ширину и высоту изображения по IndexPath
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
}
