//
//  NewsfeedPresenter.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    weak var viewController: NewsfeedDisplayLogic?
    //    ОБъект нашего протокола с инициализировали под класс FeedCellLayoutCalculator. Содержит в себе метод, который считает размеры объектов (post text, attachment photo), куда передаём ширину нашего экрана UIScreen.main.bounds.width
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    //    Создаём форматер нашей даты
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        //        Язык - русский
        dateFormatter.locale = Locale(identifier: "ru-RU")
        //        Вид отображения
        dateFormatter.dateFormat = "d MMMM 'в' HH:mm"
        return dateFormatter
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        //  Посколько мы из Интректора вызвали request.getNewsFeed попадаем сюда, то
        switch response {
        
        //        Данные которые получили и обработали (свернули в модель для отображения нужного нам формата) передаём в файл viewController
        case .presentNewsfeed(feed: let feed):
            
            //        Полученные данные из сети вставляем в наш конвертер
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
            } 
            //        Вставляем в структуру данных ячейки сконвертируемый формат полученных данных из сети
            let feedViewModel = FeedViewModel.init(cells: cells)
            //        Передаём в отображение нашу модель
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        }
    }
    
    //        Конвертируем формат FeedResponse.items в формат FeedCellViewModel.cells
    private func cellViewModel( from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        
        
        let profiles = self.profile(for: feedItem.sourceId, profile: profiles, groups: groups)
        //        Достаём формат даты 1970 года для нешего feedItem.date
        let date = Date(timeIntervalSince1970: feedItem.date)
        //        Записываем нашу дату настроенной в DateFormatter
        let dateTitle = dateFormatter.string(from: date)
        //        Достаём наш пост
        let photoAttachment = self.photoAttachment(feedItem: feedItem)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, attachmentPhoto: photoAttachment)
        //        Возвращаем нашу структуру с данными для ячейки
        return FeedViewModel.Cell.init(iconUrlString: profiles.photo,
                                       name: profiles.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       photoAttachment: photoAttachment,
                                       sizes: sizes)
    }
    
    //    Метод, который отсортирует sourceId на положительные, отрицательные и достанет необходимый id длы вывода фото, имя и даты
    private func profile(for sourceId: Int, profile: [Profile], groups: [Group]) -> ProfileRepresentableProtocol {
        
        //        Если sourceId положительный, то будет заполняться профилями, в другом случае группами
        let profilesOrGroups: [ProfileRepresentableProtocol] = sourceId >= 0 ? profile : groups
        //       Если sourceId > 0, то возвращаем sourceId, если <, то sourceId меняет знак с "-" на положительный
        let normalSourceid = sourceId >= 0 ? sourceId : -sourceId
        //         Ищем информацию о текущем посте
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            //            Пробегаемся по всему массиву profilesOrGroups и первый у кого совпал, того мы и запоминаем
            myProfileRepresentable.id == normalSourceid
        }
        return profileRepresentable! 
    }
    
    //    Проверям наличие изображения и возвращаем его
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        //        Проверяем наличие фото, пробегаясь по attachments через compactMap
        guard let photo = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
            //            Из массива фотографий берём первое фото
        }), let firstPhoto = photo.first else {
            return nil
        }
        //        Передаём в нашу модель данные поста: адрес, ширина, высота
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
}
