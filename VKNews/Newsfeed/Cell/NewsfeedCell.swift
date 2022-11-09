//
//  NewsfeedCell.swift
//  VKNews
//
//  Created by Rail on 04.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Создаём протокол, который будет иметь (читабельные) св-ва
protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachment: FeedCellPhotoAttachmentViewModel? { get }
}

//   Протокол с размерами получаемого изображения поста
protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

//   Наша ячейка в таблице
class NewsfeedCell: UITableViewCell {
    
    //    Идентификатор ячейки
    static let reuseId = "NewsfeedCell"
    
    //    Задний view нашей ячейки
    @IBOutlet weak var backView: UIView!
    //    Иконка с отображением группы или профиля человека
    @IBOutlet weak var iconImageView: WebImageView!
    //    Название группы и или имя профиля
    @IBOutlet weak var namelabel: UILabel!
    //    Дата опубликования
    @IBOutlet weak var dateLabel: UILabel!
    //    Будет содержать в себе текст
    @IBOutlet weak var postLabel: UILabel!
    //    Кол-во лайков
    @IBOutlet weak var likesLabel: UILabel!
    //    Кол-во комментарий
    @IBOutlet weak var commentsLabel: UILabel!
    //    Лейбл с кол-ом репостов
    @IBOutlet weak var sharesLabel: UILabel!
    //    Кол-во просмотров
    @IBOutlet weak var viewsLabel: UILabel!
    //    Изображение со стены
    @IBOutlet weak var postImageView: WebImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        Метод с доп изменением объектов экрана
        prepareObject()
    }
    
    //    Подготовка объектов к отображению
    private func prepareObject() {
        //        Если iconImageView существует, то код ниже выполняется????
        if let iconImageView = iconImageView {
            //            Делаем нашу иконку круглой
            iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
            iconImageView.clipsToBounds = true
            //            Скругляем углы нашего фона
            backView.layer.cornerRadius = 10
            backView.clipsToBounds = true
            //            Убираем заливку и выделение ячейки при нажатии
            backgroundColor = .clear
            selectionStyle = .none
        }
    }
    
    //    Передаём нашим элементам данные
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageUrl: viewModel.iconUrlString)
        namelabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        //        Проверяем наличие фото
        if let  photoAttachment = viewModel.photoAttachment {
            //            Если фото имеется, то отображаем его на экране
            postImageView.set(imageUrl: photoAttachment.photoUrlString)
            //            И отображаем postImageView
            postImageView.isHidden = false
        } else {
            //        Если изображения нет, то postImageView скрываем
            postImageView.isHidden = true
        }
    }
}

