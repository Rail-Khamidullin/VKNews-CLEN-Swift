//
//  NewsfeedLayoutCalculator.swift
//  VKNews
//
//  Created by Rail on 09.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Структура с размерами текста и изображения
struct Sizes: FeedCellSizes {
    //    Текствое поле
    var postLabelFrame: CGRect
    //    Изображение
    var attacmentFrame: CGRect
    //    Вьюшки с: репостами, лайками, просмотрами и комментариями
    var buttonViewFrame: CGRect
    //    Вьюшка с именем группы или человека, изображение профиля и время опубликования
    var totalHeight: CGFloat
}

//   Фиксируем размеры BackView
struct Constants {
    //    Расположение BackView
    static let backInsets = UIEdgeInsets(top: 0, left: 8, bottom: 7, right: 8)
    //    Высота topView
    static let topViewHight: CGFloat = 36
    //    Расположение пост лейбла на экране
    static let postLabelInsets = UIEdgeInsets(top: 8 + topViewHight + 8, left: 8, bottom: 8, right: 8)
    //    Высота шрифта пост лейбла
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    //    Высота buttonView
    static let buttonViewHeight: CGFloat = 44
}

//   Создаём протокол, который будет хранить в себе метод определения размеров текста и изображения
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attachmentPhoto: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes
}

//   Логика определения размеров
final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    //    Ширина экрана
    private let screenWidth: CGFloat
    
    //    Инициализируем наше св-во где шириа экрана равна минимальному размеру экрана проверяя ширину и высоту экрана
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    //    Определяем размеры объектов
    func sizes(postText: String?, attachmentPhoto: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {
        
        //        Размеры заднего фона ячейки
        let backViewWith = screenWidth - Constants.backInsets.left - Constants.backInsets.right
        
        // MARK: - Работа с postlabelFrame
        
        //        origin отвечает за точку отсчёта координат (левый верхний угол объекта), а size за размеры
        var postlabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top ),
                                    size: CGSize.zero)
        
        //        Проверяем наличие текста, если он есть, то проваливаемся, если нет, то он равен 0 (CGSize.zero)
        if let text = postText, !text.isEmpty {
            //            Определяем ширину и высоту пост лейбла
            let width = backViewWith - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            let height = text.height(width: width, font: Constants.postLabelFont)
            //            Присваиваем нашему посту размеры изображения
            postlabelFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - работа с attachmentPhoto Frame
        
        //        Первый поиск координаты y. Если пост с текстом отсутсвует, то y будет равен сумме максимальной выосты лейбла с постом + констрейнт от поста с тексотм до изображения новости
        let attachmentTop = postlabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postlabelFrame.maxY + Constants.postLabelInsets.bottom
        
        //        Второй вариант поиска координаты y
        //        let photoY = (8 + Constants.topViewHight + 8 + postlabelFrame.size.height + 8)
        let photoX = CGFloat(8)
        //        Устанавливаем расположение и размеры изображения
        var attachmentFrame = CGRect(origin: CGPoint(x: photoX, y: attachmentTop), size: CGSize.zero)
        //        Если фото есть
        if let photoAttachment = attachmentPhoto {
            //            Ширина изображения
            let width = postlabelFrame.width
            let photoWidth: Float = Float(photoAttachment.width)
            //            Высота изображения
            let photoHeight: Float = Float(photoAttachment.height)
            //            Соотношение высоты к ширине
            let ratio = CGFloat(photoHeight / photoWidth)
            //            Добавдяем размеры
            attachmentFrame.size = CGSize(width: width, height: backViewWith * ratio)
        }
        
        // MARK: - Работа с buttonViewFrame
        
        //        Координата X
        let buttonX = CGFloat(8)
        //        Первый варинат поиска координаты Y
        //        let buttonY = (attachmentTop + attachmentFrame.size.height + 7 + 3)
        //        Второй вариант поиска координаты Y
        let buttonY = max(postlabelFrame.maxY, attachmentFrame.maxY)
        //        Ширина buttonView
        let buttonWith = backViewWith - 8 - 8
        //        Расположение и размеры buttonView
        let buttonViewFrame = CGRect(x: buttonX, y: buttonY, width: buttonWith, height: Constants.buttonViewHeight)
        
        // MARK: - работа над общей высотой ячейки
        
        let cellHeight = buttonViewFrame.maxY + Constants.backInsets.bottom
        
        //        Временные размеры
        return Sizes(postLabelFrame: postlabelFrame,
                     attacmentFrame: attachmentFrame,
                     buttonViewFrame: buttonViewFrame,
                     totalHeight: cellHeight)
    }
}
