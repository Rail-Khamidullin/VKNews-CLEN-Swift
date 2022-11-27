//
//  RowLayout.swift
//  VKNews
//
//  Created by Rail on 18.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Передаём данные делегата в RowLayout
protocol RowlayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

//   Создаём кастомный Layout для стандартизации размеров получаемых изображений поста
class RowLayout: UICollectionViewLayout {
    
    //    Устанавливаем делегат
    weak var delegate: RowlayoutDelegate!
    
    //    Кол-во строк
    static var numberOfRows = 1
    //    Отступы изображения от краёв ячейки (заполнение ячейки)
    fileprivate var cellPadding: CGFloat = 8
    //     Создаём кеш для наших размеров и расположения изображений
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    //    Храннеие размеров контента (прямоугольник)
    fileprivate var contentWidth: CGFloat = 0
    
    /// Константа
    fileprivate var contentHeight: CGFloat {
        //        Если collectionView нет
        guard let collectionView = collectionView else { return 0 }
        //        Если collectionView есть
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    //    Переопределяем размеры, которые возвращают наружу 2 значения с размерами содержимого
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //    Подготовка изображений
    override func prepare() {
        //        Обнуляем кеш и contentWidth, потому что при переиспользовании после первой коллекции изображений последующие будут иметь размеры и расположение  предыдущего
        contentWidth = 0
        cache = []
        //        Проверяем наличие изображения в кеш и наличие collectionView
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        //        Достаём все изображения
        var photos = [CGSize]()
        //        Пробегаемся по массиву ячеек коллекшен вью
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            //            Берем indexPath каждого элемента нашей 0-ой секции
            let indexPath = IndexPath(item: item, section: 0)
            //            Достаём размеры каждого изображения
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: indexPath)
            //            Добавляем в массив с изображениями
            photos.append(photoSize)
        }
        
        //        Берем ширину нашего супервью
        let superviewWith = collectionView.frame.width
        //        Достаём строку, которая имеет самое маленькое расширение, чтобы вычислить высоту строки
        guard var rowHeight = RowLayout.rowHeightCounter(superviewWidth: superviewWith, photosArray: photos) else {
            return
        }
        
        rowHeight = rowHeight / CGFloat(RowLayout.numberOfRows)
        
        //        Массив с соотношением сторон каждого изображения
        let photosRatios = photos.map { $0.height / $0.width }
        //        Определяем вертикальные координаты
        var yOffset = [CGFloat]()
        //        Пробегаемся по всем строкам
        for row in 0 ..< RowLayout.numberOfRows {
            //            Координата y для первой строки будет = 0, для второй 10, для третьей 20 и т.д. в зависимости от того сколько numberOfRows нам необходимо
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        //        Горизонтальная координата x
        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        //        Переменная со строкой
        var row = 0
        
        //        Перебераем все элементы collectionView. Для каждой ячейки создаём собственый размер и фиксируем местоположение в двух массивах xOffset и yOffset
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            //            Берём indexPath всех элементов 0 секции
            let indexPath = IndexPath(item: item, section: 0)
            //             Вытаскиваем соотношение сторон по конкретной картинки
            let ratio = photosRatios[indexPath.row]
            //            Исходное соотношение сторон со своими размерами
            let width = rowHeight / ratio
            //            Устанавливаем расположение и размеры изображения в ячейке
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            //            Добавляем к размерам изображения отступы с 4-х сторон
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            //            Сконвертируем insetFrame в формат, чтобы можно было добавить его в кеш
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            //            Следующий элемент который расширяется в право (contentWidth)
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    //        Функция типа для расчёта высоты для одной строки на основе полученных размеров изображений
    static func rowHeightCounter(superviewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        //        Высота изображения
        var rowHeight: CGFloat
        //        Находим минимальное соотношение сторон
        let photoWithMinRatio = photosArray.min { (first, second) -> Bool in
            (first.height / first.width) < (second.height / second.width)
        }
        //        Убираем опционал
        guard let myPhotoWithMinRatio = photoWithMinRatio else { return nil }
        //        Берем разницу сторон ширины супервью и размера минимальной ширины изображения
        let difference = superviewWidth / myPhotoWithMinRatio.width
        //        Высота будет вычеслена
        rowHeight = myPhotoWithMinRatio.height * difference
        
        rowHeight = rowHeight * CGFloat(RowLayout.numberOfRows)
        //        Возвращаем высоту изображения
        return rowHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //        Создаём массив с атрибутами, который видят пользователи
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        //        Пробегаемся по кеш и смотрим является ли данный атрибут у пользователя на экране
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                //                Если так, то добавляем их в массив, который и возвращаем
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
