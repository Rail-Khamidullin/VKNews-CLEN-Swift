//
//  GradientView.swift
//  VKNews
//
//  Created by Rail on 25.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit


//   Класс с настройкой изображения на заднем фоне новостной ленты с помощью GradientView
class GradientView: UIView {
    
    //    Задаем переменные цветом для отображение в массиве градиента. В случае, если необходимо изменять данные цвета через Storyboard, то добавляем к нашим св-ва приставку @IBInspectable и делаем их опциональными (убираем н/п UIColor = .red), а также добавляем didSet. После этого в Storyboard в атрибьют инспекторе появятся 2 св-ва с цветами.
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    
    //    Подключаем градиент
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //    Посколько мы работаем через сториборд, а не программно, то пользуемся инициализатором через кодер
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        Вызываем setupGradient
        setupGradient()
    }
    
    //    Задаём размеры градиент вью
    override func layoutSubviews() {
        super.layoutSubviews()
        //        Растягиваем по всем границам
        gradientLayer.frame = bounds
    }
    
    //    Подключаем градиент вью для отображения
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors()
        //        Расположение цветов
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    private func setupGradientColors() {
        //        задаём цвета
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
