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
    //    Размер кнопки
    var moreTextButtonFrame: CGRect
    //    Изображение
    var attacmentFrame: CGRect
    //    Вьюшки с: репостами, лайками, просмотрами и комментариями
    var buttonViewFrame: CGRect
    //    Вьюшка с именем группы или человека, изображение профиля и время опубликования
    var totalHeight: CGFloat
}

//   Создаём протокол, который будет хранить в себе метод определения размеров текста и изображения
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attachmentsPhoto: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

//   Логика определения размеров
final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    //    Ширина экрана
    private let screenWidth: CGFloat
    
    //    Инициализируем наше св-во где ширина экрана равна минимальному размеру экрана проверяя ширину и высоту экрана
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    //    Определение динамических размеров объектов
    func sizes(postText: String?, attachmentsPhoto: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        
        //        Флажок, определяющий показывать кнопку для большого текста или нет
        var showMoreTextButton = false
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
            var height = text.height(width: width, font: Constants.postLabelFont)
            //            Создаём максимальное кол-во строк для отображения без кнопки
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            //            Если на кнопку moreTextButton не нажали и текст меньше нашей константы, то
            if !isFullSizedPost && height > limitHeight {
                //                высота поста составляет
                height = Constants.minifiedPostLines * Constants.postLabelFont.lineHeight
                showMoreTextButton = true
            }
            //            Присваиваем нашему посту размеры изображения
            postlabelFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - работа с moreTextButtonFrame
        
        //        Размер кнопки = 0
        var moreTextButtonSize = CGSize.zero
        //        Если кнопку необходимо показать
        if showMoreTextButton {
            //            То устанавливаем ей размер
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        //        Расположение кнопки
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postlabelFrame.maxY)
        //        Устанавливаем ей размер и расположение
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        // MARK: - работа с attachmentPhoto Frame
        
        //        Поиск координаты y. Если пост с текстом отсутсвует, то y будет равен сумме максимальной выосты лейбла с постом + констрейнт от поста с текстом до изображения новости
        let attachmentTop = postlabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        //        Устанавливаем расположение и размеры изображения
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        //        Если фото есть
        if let photoAttachments = attachmentsPhoto.first {
            //            Ширина изображения
            let photoWidth: Float = Float(photoAttachments.width)
            //            Высота изображения
            let photoHeight: Float = Float(photoAttachments.height)
            //            Соотношение высоты к ширине
            let ratio = CGFloat(photoHeight / photoWidth)
            //            Если изображение 1
            if attachmentsPhoto.count == 1 {
                //            Добавдяем размеры
                attachmentFrame.size = CGSize(width: backViewWith, height: backViewWith * ratio)
                //                Если изображений несколько
            } else if attachmentsPhoto.count > 1 {
                //            Создаём массив с размерами фото
                var photos = [CGSize]()
                for photo in attachmentsPhoto {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photos.append(photoSize)
                }
                //                Высота строки
                let rowHeight = RowLayout.rowHeightCounter(superviewWidth: backViewWith, photosArray: photos)
                attachmentFrame.size = CGSize(width: backViewWith, height: rowHeight!)
            }
        }
        
        // MARK: - Работа с buttonViewFrame
        
        //        Первый варинат поиска координаты Y
        //        let buttonY = (attachmentTop + attachmentFrame.size.height + 7 + 3)
        //        Второй вариант поиска координаты Y
        let buttonY = max(postlabelFrame.maxY, attachmentFrame.maxY)
        //        Расположение и размеры buttonView
        let buttonViewFrame = CGRect(origin: CGPoint(x: 0, y: buttonY),
                                     size: CGSize(width: backViewWith, height: Constants.buttonViewHeight))
        
        // MARK: - работа над общей высотой ячейки
        
        //        Общая высота ячейки складывается из максимальной координаты Y плюс расстояние от кнопки до BackView
        let cellHeight = buttonViewFrame.maxY + Constants.backInsets.bottom
        
        //        Размеры
        return Sizes(postLabelFrame: postlabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     attacmentFrame: attachmentFrame,
                     buttonViewFrame: buttonViewFrame,
                     totalHeight: cellHeight)
    }
}
