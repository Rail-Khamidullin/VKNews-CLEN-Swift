//
//  NewsfeedPresenter.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

//   Через данный метод интерактор общается с презентером и зависит от абстракцииф
protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    //    Презентер общается с контроллером через абстракцию
    weak var viewController: NewsfeedDisplayLogic?
    //    ОБъект нашего протокола с инициализировали под класс FeedCellLayoutCalculator. Содержит в себе метод, который считает размеры объектов (post text, attachment photo), куда передаём ширину нашего экрана UIScreen.main.bounds.width
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    //    Создаём форматтер нашей даты
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        //        Язык - русский
        dateFormatter.locale = Locale(identifier: "ru-RU")
        //        Вид отображения
        dateFormatter.dateFormat = "d MMMM 'в' HH:mm"
        return dateFormatter
    }()
    
    //    Через данный метод интерактор общается с презентером
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        //  Посколько мы из Интректора вызвали request.getNewsFeed попадаем сюда, то
        switch response {
        //        Данные которые получили и обработали (свернули в модель для отображения нужного нам формата) передаём в файл viewController
        case .presentNewsfeed(feed: let feed, let reveledPostIds):
            //        Полученные данные из сети вставляем в наш конвертер
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: reveledPostIds)
            }
            //            Настраиваем отображение кол-ва записей, склоняем слово "запись" в зависимости от кол-ва через Localizable.stringsdict
            let fotterTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""), cells.count)
            //        Вставляем в структуру данных ячейки (нижний колонтитутл) сконвертируемый формат полученных данных из сети
            let feedViewModel = FeedViewModel.init(cells: cells, footerTitle: fotterTitle)
            //        Передаём в отображение нашу модель
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
            
        //            Через данный кейч передаём изображение пользователя контакта в title навигейшн бара
        case .presentUserInfo(user: let user):
            //            Вставляем в структуру данных ячейки сконвертируемый формат полученных данных из сети
            let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
            //            Передаём в отображение нашу модель
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayUser(userViewModel: userViewModel))
            
        //            Передаём нижний колонтитул в отображение на экран
        case .presentFooterLoader:
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayFooterLoader)
        }
    }
    
    //        Конвертируем формат FeedResponse.items в формат FeedCellViewModel.cells
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profiles = self.profile(for: feedItem.sourceId, profile: profiles, groups: groups)
        //        Достаём формат даты 1970 года для нешего feedItem.date
        let date = Date(timeIntervalSince1970: feedItem.date)
        //        Записываем нашу дату настроенной в DateFormatter
        let dateTitle = dateFormatter.string(from: date)
        //        Достаём наши фото
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        //        Пробегаемся по массиву revealedPostIds и если какой-нибудь postId совпал с конкретной ячейкой
        let isFullSized = revealedPostIds.contains { (postId) -> Bool in
            return postId == feedItem.postId
        }
        //        Размеры ячейки
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, attachmentsPhoto: photoAttachments, isFullSizedPost: isFullSized)
        //        При появлении в тексте знаков <br>, будут заменяться на \n (пробел)
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        //        Возвращаем нашу структуру с данными для ячейки
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profiles.photo,
                                       name: profiles.name,
                                       date: dateTitle,
                                       text: postText,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttachments: photoAttachments,
                                       sizes: sizes)
    }
    
    //    Форматируем отображение кол-ва лайков, просмотров и др. для удобочитаемого вида
    private func formattedCounter( _ counter: Int?) -> String? {
        //        Проверяем наличие числа
        guard let counter = counter, counter > 0 else { return nil }
        //        Кастим Int в String
        var counterString = String(counter)
        //        Если от 4 до 6 символов в кол-ве просмотров, лайков и т.д.
        if 4...6 ~= counterString.count {
            //            То отбрасывается 3 последние числа и добавляем символ К (тысяча)
            counterString = String(counterString.dropLast(3)) + "K"
            //            Если больше 6 символов
        } else if counterString.count > 6 {
            //            То отбрасываем последние 6 символов и добавляем символ М (миллион)
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
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
    
    //    Метод, который принимает структуру FeedItem и обновляет данные в структуре для дальнейшей передачи для отображения
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        //        Проверяем наличие фотографий
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            //            Если фото имеется, то получаем его
            guard let photo = attachment.photo else { return nil }
            //            Добавляем данные наших фото в модель
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.height)
        }
    }
}
