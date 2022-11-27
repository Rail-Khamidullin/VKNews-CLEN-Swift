//
//  FooterView.swift
//  VKNews
//
//  Created by Rail on 24.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

// Настройка нижнего колонтитула
class FooterView: UIView {
    
    //    Лейбл в нижнем колонтитуле
    private var footerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        //        Центрируем текст
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //    Активити индикатор в нижнем колонтитуле
    private var loaderIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        //        Будет исчезать после остановки загрузки
        loader.hidesWhenStopped = true
        //        Возможность к растяжению
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        Размещаем объекты на экране
        addSubview(footerLabel)
        addSubview(loaderIndicator)
        //        Настройка констрейнтов
        footerLabel.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: nil,
                           trailing: trailingAnchor,
                           padding: UIEdgeInsets(top: 8, left: 20, bottom: 777, right: 20))
        
        loaderIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loaderIndicator.topAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    //    Метод по запуску индикатора
    func showLoader() {
        loaderIndicator.startAnimating()
    }
    //    Метод по остановке индикатора
    func setTitle(_ title: String?) {
        //        footerLabel будет принимать текст для отображения
        footerLabel.text = title
        loaderIndicator.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
