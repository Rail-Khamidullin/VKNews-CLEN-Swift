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
    var postLabelFrame: CGRect
    var attacmentFrame: CGRect
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
        
        //        Временные размеры
        return Sizes(postLabelFrame: CGRect.zero, attacmentFrame: CGRect.zero)
    }
}
