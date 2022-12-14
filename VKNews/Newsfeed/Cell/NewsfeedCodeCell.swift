//
//  NewsfeedCodeCell.swift
//  VKNews
//
//  Created by Rail on 11.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import UIKit

//   Делегат, который будет раскрывать ячейку с текстом по нажатию на кнопку
protocol NewsFeedCodeDelegate: class {
    //    Расскрывает пост по определённой ячейке
    func revealPost(for cell: NewsfeedCodeCell)
}

//   Расположение объектов ПРОГРАММНО !!!
class NewsfeedCodeCell: UITableViewCell {
    
    //    Айди нашей ячейки
    static let reuseId = "NewsfeedCodeCell"
    //    Создадим переменную делегата выше
    weak var delegate: NewsFeedCodeDelegate?
    
    /// Первый слой_____________________________________________
    //    Основной задний фон экрана
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Второй слой______________________________________________
    //    TopView для изображения профиля, имя или название и даты размещения поста
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //   Лейбл с постом в новостной ленте
    private let postLabel: UITextView = {
        let textView = UITextView()
        textView.font = Constants.postLabelFont
        textView.textColor = #colorLiteral(red: 0.2276472747, green: 0.2322267592, blue: 0.2365691364, alpha: 1)
        //        Отключаем прокрутку
        textView.isScrollEnabled = false
        //        Включаем реакцию на нажатие
        textView.isSelectable = true
        //        Включаем взаимодействие с пользователем
        textView.isUserInteractionEnabled = true
        //        Редактирование не возможно
        textView.isEditable = false
        //        Посколько отступы от краёв у лейбла (бывший объект) и textView разные, необходимо сделать таким же
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        //        Указываем, что ВСЁ возможно для обнаружения в посте: ссылки, адреса, телефоны, календари и др.
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        
        return textView
    }()
    //    Кнопка открытия полного отображения текста поста
    private let moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(#colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    //    Создаём объект GalleryCollectionView
    private let galleryCollectionView = GalleryCollectionView()
    //    Изображения с поста
    private let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.3098039216, blue: 0.3294117647, alpha: 1)
        return imageView
    }()
    //    bottomView для хранения объектов с просмотрами, лайками, комментариями и репостами
    private let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// Третий слой на topView_________
    private let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    //    Имя сообщества или человека
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2276472747, green: 0.2322267592, blue: 0.2365691364, alpha: 1)
        return label
    }()
    //    Дата публикации поста
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return label
    }()
    
    /// Третий слой на BottomView__________________________________
    //    Вьшка с лайками
    private let likesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //    Вьшка с комментариями
    private let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //    Вьшка с репостами
    private let sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //    Вьшка с просмотрами
    private let viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Четвёртый слой на BottomView_________
    //    Заполнение ячейки изображения: лайки, комментарии, репосты, просмотры
    private let likesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "like")
        return imageView
    }()
    //    Иконка комментарии
    private let commentsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "comment")
        return imageView
    }()
    //    Иконка репостов
    private let sharesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "share")
        return imageView
    }()
    //    Иконка просмотров
    private let viewsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "eye")
        return imageView
    }()
    //    Заполнение ячейки с кол-ом: лайки, комментарии, репосты, просмотры
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        Регулировка шрифта по ширине. В зависимсоти от кол-ва символов шрифт будет уменьшаться или восстанавливаться в исходное значение
        label.lineBreakMode = .byClipping
        return label
    }()
    //    Лейбл с кол-ом комментарий
    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        Регулировка шрифта по ширине. В зависимсоти от кол-ва символов шрифт будет уменьшаться или восстанавливаться в исходное значение
        label.lineBreakMode = .byClipping
        return label
    }()
    //    Лейбл с кол-ом репостов
    private let sharesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        Регулировка шрифта по ширине. В зависимсоти от кол-ва символов шрифт будет уменьшаться или восстанавливаться в исходное значение
        label.lineBreakMode = .byClipping
        return label
    }()
    //    Лейбл с кол-ом просмотров
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        Регулировка шрифта по ширине. В зависимсоти от кол-ва символов шрифт будет уменьшаться или восстанавливаться в исходное значение
        label.lineBreakMode = .byClipping
        return label
    }()
    
    //    Метод для многократного использования ячейки
    override func prepareForReuse() {
        iconImageView.set(imageUrl: nil)
        postImageView.set(imageUrl: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //            Делаем нашу иконку круглой
        iconImageView.layer.cornerRadius = Constants.topViewHight / 2 
        iconImageView.clipsToBounds = true
        //            Убираем заливку и выделение ячейки при нажатии
        backgroundColor = .clear
        selectionStyle = .none
        //            Скругляем углы нашего фона
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        //        Добавляем действие по нажатию на кнопку
        moreTextButton.addTarget(self, action: #selector(moreTextButtonTouch), for: .touchUpInside)
        
        overlayFirstLayer()   // Первый слой
        overlaySecondLayer()   // Второй слой
        overlayThirdLayerOnTopView()   // Третий слой на topView
        overlayThirdLayerOnBottomView()   // Третий слой на bottomView
        overlayFourthLayerOnBottomViewViews()   // Четвёртый слой на ячейках BottomView
    }
    
    //    По нажатию на кнопку делегируем выполнение метода в NewsfeedViewController
    @objc private func moreTextButtonTouch() {
        delegate?.revealPost(for: self)
    }
    
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
        bottomView.frame = viewModel.sizes.buttonViewFrame
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame
        
        //        Проверяем наличие фото
        if let photoAttachment = viewModel.photoAttachments.first, viewModel.photoAttachments.count == 1 {
            //            Если фото имеется, то отображаем его на экране
            postImageView.set(imageUrl: photoAttachment.photoUrlString)
            //            И отображаем postImageView
            postImageView.isHidden = false
            //            Скрываем нашу коллекцию
            galleryCollectionView.isHidden = true
            //            Передаём размеры фото в postImageView
            postImageView.frame = viewModel.sizes.attacmentFrame
            //            Если мы получаем несколько изображений, то устанавливаем размеры для galleryCollectionView
        } else if viewModel.photoAttachments.count > 1 {
            galleryCollectionView.frame = viewModel.sizes.attacmentFrame
            //            Скрываем postImageView
            postImageView.isHidden = true
            //            Открываем galleryCollectionView
            galleryCollectionView.isHidden = false
            //            Передаём фото в GalleryCollectionView -> photos
            galleryCollectionView.set(photos: viewModel.photoAttachments)
        }
        else {
            //        Если изображения нет, то postImageView и galleryCollectionView скрываем
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
    }
    
    //    Накладываем четвёртый слой на ячейки BottomView
    private func overlayFourthLayerOnBottomViewViews() {
        //        Добавляем объекты в ячейки BottomView: лайки, комментарии, просмотры и репосты
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)
        
        commentsView.addSubview(commentsImage)
        commentsView.addSubview(commentsLabel)
        
        sharesView.addSubview(sharesImage)
        sharesView.addSubview(sharesLabel)
        
        viewsView.addSubview(viewsImage)
        viewsView.addSubview(viewsLabel)
        //        Устанавливаем привязку объектов
        helpInFourthLayer(view: likesView, imageView: likesImage, label: likesLabel)
        helpInFourthLayer(view: commentsView, imageView: commentsImage, label: commentsLabel)
        helpInFourthLayer(view: sharesView, imageView: sharesImage, label: sharesLabel)
        helpInFourthLayer(view: viewsView, imageView: viewsImage, label: viewsLabel)
    }
    
    //    Метод, который устанвливает привязку объектов во view
    private func helpInFourthLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        //        imageView
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.bottomViewViewsIconSize).isActive = true
        imageView.heightAnchor .constraint(equalToConstant: Constants.bottomViewViewsIconSize).isActive = true
        //        label
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 3).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    //    Накладываем третий слой на BottomView
    private func overlayThirdLayerOnBottomView() {
        //        Добавляем объекты на bottomView
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)
        
        ///   Прописываем констрейнты третьего слоя bottomView__________
        //        likesView
        likesView.anchor(top: bottomView.topAnchor,
                         leading: bottomView.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.bottomViewViewWidth,
                                      height: Constants.bottomViewViewHeight))
        //        commentsView
        commentsView.anchor(top: bottomView.topAnchor,
                            leading: likesView.trailingAnchor ,
                            bottom: nil,
                            trailing: nil,
                            size: CGSize(width: Constants.bottomViewViewWidth,
                                         height: Constants.bottomViewViewHeight))
        //        sharesView
        sharesView.anchor(top: bottomView.topAnchor,
                          leading: commentsView.trailingAnchor,
                          bottom: nil,
                          trailing: nil,
                          size: CGSize(width: Constants.bottomViewViewWidth,
                                       height: Constants.bottomViewViewHeight))
        //        viewsView
        viewsView.anchor(top: bottomView.topAnchor,
                         leading: nil ,
                         bottom: nil,
                         trailing: bottomView.trailingAnchor,
                         size: CGSize(width: Constants.bottomViewViewWidth,
                                      height: Constants.bottomViewViewHeight))
    }
    
    //    Накладываем третий слой на topView
    private func overlayThirdLayerOnTopView() {
        //        Добавляем объекты на topView
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        ///   Прописываем констрейнты третьего слоя topView__________
        //        iconImageView
        iconImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.topViewHight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.topViewHight).isActive = true
        //        nameLabel
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 7).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Constants.topViewHight / 2 - 2).isActive = true
        //        dateLabel
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 7).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14 ).isActive = true 
    }
    
    //    Накладываем второй слой
    private func overlaySecondLayer() {
        //        Добавляем backView на экран
        backView.addSubview(topView)
        backView.addSubview(postLabel)
        backView.addSubview(moreTextButton)
        backView.addSubview(postImageView)
        backView.addSubview(galleryCollectionView)
        backView.addSubview(bottomView)
        
        ///   Прописываем констрейнты второго слоя__________
        //        topView constrains
        topView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 8).isActive = true
        topView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -8).isActive = true
        topView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.topViewHight).isActive = true
        
        // postlabel constraints
        // не нужно, так как размеры задаются динамически
        
        // moreTextButton constraints
        // не нужно, так как размеры задаются динамически
        
        // postImageView constraints
        // не нужно, так как размеры задаются динамически
        
        // bottomView constraints
        // не нужно, так как размеры задаются динамически
    }
    
    //    Накладываем первый слой
    private func overlayFirstLayer() {
        //        Добавляем backView на экран
        addSubview(backView)
        
        // BackView constraints (расположение указано в файле NewsfeedLayoutCalculator -> Constants)
        backView.fillSuperview(padding: Constants.backInsets)
    }
    
    //    Обязательный метод
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
