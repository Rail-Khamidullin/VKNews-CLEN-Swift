//
//  TitleView.swift
//  VKNews
//
//  Created by Rail on 21.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Протокол с url адресом
protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

//   Класс, который будет интегрирован в навигейшн бар
class TitleView: UIView {
    
    //    Текстовое поле поисковика - экземпляр класса InsetableTextField
    private var myTextField = InsetableTextField()
    //    Аватар профиля
    private var myAvatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        //        Округляем картинку
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //         Чтобы мы могли его растягивать
        translatesAutoresizingMaskIntoConstraints = false
        //        Добавим 2 объекта в наш bar
        addSubview(myAvatarView)
        addSubview(myTextField)
        //        Добавляем констрейнты
        makeCounstrains()
    }
    
    //    Метод для получения иконки профиля из сети по url адресу из протокола TitleViewViewModel
    func set(userViewModel: TitleViewViewModel) {
        myAvatarView.set(imageUrl: userViewModel.photoUrlString)
    }
    
    //    Установим констрейнты
    private func makeCounstrains() {
        
        /// myAvatarView
        myAvatarView.anchor(top: topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 4, left: 777, bottom: 777, right: 4))
        //        Высота и ширина
        myAvatarView.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        myAvatarView.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        
        /// myTextField
        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: myAvatarView.leadingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }
    
    //    View, которое добавляется в навигейшн бар обычно подстраивается под его размеры через спец метод
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    //    Скругляем изображение через спец метод
    override func layoutSubviews() {
        super.layoutSubviews()
        //        Обрезаем изображение до границ
        myAvatarView.layer.masksToBounds = true
        //        Делаем иконку круглой
        myAvatarView.layer.cornerRadius = myAvatarView.frame.width / 2 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
