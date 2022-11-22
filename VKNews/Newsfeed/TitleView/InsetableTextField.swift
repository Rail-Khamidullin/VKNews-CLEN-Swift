//
//  InsetableTextField.swift
//  VKNews
//
//  Created by Rail on 21.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Класс с настройками текстового поля для навигейшн бара
class InsetableTextField: UITextField {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        placeholder = "Поиск"
        font = UIFont.systemFont(ofSize: 14)
        //        Добавлена кнопка в текстовом поле справа, в которая появляется после ввода текста. Нажатие на неё удаляет весь текст
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        //        Изображение поиска в текстовом поле
        let image = UIImage(named: "search")
        //        Расположим её слева
        leftView = UIImageView(image: image)
        //        Координаты и размеры
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        //        Поведение
        leftViewMode = .always
    }
    
    //    Чтобы увеличить расстояние от левого края текстового поля до изображение используем метод
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    //    Для увеличение расстояние от текста плейсхолдера до изображения в текстовом поле используется 2 метода
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
