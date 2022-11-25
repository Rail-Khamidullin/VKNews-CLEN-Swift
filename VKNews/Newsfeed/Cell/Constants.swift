//
//  Constants.swift
//  VKNews
//
//  Created by Rail on 11.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

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
    //    Высота ячейки просмотров в buttonView
    static let bottomViewViewHeight: CGFloat = 44
    //    Ширина ячейки просмотров в buttonView
    static let bottomViewViewWidth: CGFloat = 80
    //    Размеры ширины и высоты для изображения обозначения ячеек (лайки, комменты и др.) в bottomView
    static let bottomViewViewsIconSize: CGFloat = 24
    //    Кол-во строк для отображения без доп кнопки
    static let minifiedPostLimitLines: CGFloat = 8
    //    Кол-во строк для отображения с доп кнопкой
    static let minifiedPostLines: CGFloat = 6
    //    Размер кнопки с раскрытием
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
    //    Отступы кнопки
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
}
