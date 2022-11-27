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
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    //    Содержит размеры изменяющихся объектов
    var sizes: FeedCellSizes { get }
}

//   Протокол с размерами получаемого изображения поста
protocol FeedCellPhotoAttachmentViewModel {
    //    Адрес изображения
    var photoUrlString: String? { get }
    //    Шириа
    var width: Int { get }
    //    Высота
    var height: Int { get }
}

//   Размеры и координаты наших объектов
protocol FeedCellSizes {
    //    Размер текста
    var postLabelFrame: CGRect { get }
    //    Размер фото
    var attacmentFrame: CGRect { get }
    //    Вьюшка с нашими объектами: лайки, комментарии, репосты и просмотры
    var buttonViewFrame: CGRect { get }
    //    Высота всей ячейки
    var totalHeight: CGFloat { get }
    //    Кнопка при большом кол-во текста в посте
    var moreTextButtonFrame: CGRect { get }
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
    @IBOutlet weak var nameLabel: UILabel!
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
    //    Вьюшка с нашими объектами: лайки, комментарии, репосты и просмотры
    @IBOutlet weak var bottomView: UIView!
    
    //    Метод для многократного использования ячейки
    override func prepareForReuse() {
        iconImageView.set(imageUrl: nil)
        postImageView.set(imageUrl: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        Метод с доп изменением объектов экрана
        prepareObject()
    }
    
    //    Подготовка объектов к отображению
    private func prepareObject() {
        
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
    
    /*
     //    Передаём нашим элементам данные
     func set(viewModel: FeedCellViewModel) {
     iconImageView.set(imageUrl: viewModel.iconUrlString)
     nameLabel.text = viewModel.name
     dateLabel.text = viewModel.date
     postLabel.text = viewModel.text
     likesLabel.text = viewModel.likes
     commentsLabel.text = viewModel.comments
     sharesLabel.text = viewModel.shares
     viewsLabel.text = viewModel.views
     //        Присваиваем размеры postLabel, postImageView, bottomView
     postLabel.frame = viewModel.sizes.postLabelFrame
     postImageView.frame = viewModel.sizes.attacmentFrame
     bottomView.frame = viewModel.sizes.buttonViewFrame
     
     //        Проверяем наличие фото
     if let photoAttachment = viewModel.photoAttachment {
     //            Если фото имеется, то отображаем его на экране
     postImageView.set(imageUrl: photoAttachment.photoUrlString)
     //            И отображаем postImageView
     postImageView.isHidden = false
     } else {
     //        Если изображения нет, то postImageView скрываем
     postImageView.isHidden = true
     }
     }
     */
}

