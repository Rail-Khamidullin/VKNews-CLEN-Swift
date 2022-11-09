//
//  NewsfeedModels.swift
//  VKNews
//
//  Created by Rail on 03.11.2022.
//  Copyright (c) 2022 Хамидуллин Раиль. All rights reserved.
//

import UIKit

//   Наша модель новостной ленты
enum Newsfeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                //        Получение новостных данных
                case getNewsFeed
            }
        }
        struct Response {
            enum ResponseType {
                //        Кейс с ассоциативным значением FeedResponse
                case presentNewsfeed(feed: FeedResponse)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                //        Кейс с ассоциативным значением FeedViewModel
                case displayNewsfeed(feedViewModel: FeedViewModel)
            }
        }
    }
}

//   Создаём структуру нашей модели данных, которая будет принимать данные из сети
struct FeedViewModel {
    //    Подписываем под протокол и реализуем его св-ва
    struct Cell: FeedCellViewModel {
        //        Иконка url страницы откуда пришёл пост
        var iconUrlString: String
        //        Имя поста
        var name: String
        //        Дата размещения поста
        var date: String
        //        Текст или изображение поста
        var text: String?
        //        Кол-во лайков
        var likes: String?
        //        Кол-во комментарий
        var comments: String?
        //        Кол-во репостов
        var shares: String?
        //        Кол-во просмотров
        var views: String?
        //        Изображение поста
        var photoAttachment: FeedCellPhotoAttachmentViewModel?
        //        Размеры объектов text и photoAttachment
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        //        URL адрес фото
        var photoUrlString: String?
        //        Ширина
        var width: Int
        //        Высота
        var height: Int
    }
    
    //    В новостной ленте присутствует массив ячеек
    let cells: [Cell]
}
