//
//  String + Height.swift
//  VKNews
//
//  Created by Rail on 10.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Расширение к нашим стрингам
extension String {
    
    //    Метод, который возвращает высоту поля в зависимсоти от кол-ва текста и шрифта
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        //        Вычисляет и возвращает ограниченный прямоугольик учитывая текст и шрифт
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        //        Возвращаем округлённое значение типа CGFloat
        return ceil(size.height)
    }
}
