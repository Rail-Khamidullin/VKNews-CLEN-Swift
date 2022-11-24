//
//  FeedResponse.swift
//  VKNews
//
//  Created by Rail on 02.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation

//   Структура новостей
struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

//   Массив новостей
struct FeedResponse: Decodable {
    //    Массив новостей для текущего пользователя
    var items: [FeedItem]
    //    Профиль выложивший новость
    var profiles: [Profile]
    //    Профиль группы, которая выложила пост
    var groups: [Group]
    //    Получение новых новостей без дублирования старых
    var nextFrom: String?
}

//   Состав массива новостей
struct FeedItem: Decodable {
    //    Идентификатор источника новостей
    let sourceId: Int
    //    Идентификатор записи на стене владельца
    let postId: Int
    //    Текст записи со стены
    let text: String?
    //    Время публикации новостей
    let date: Double
    //    Комментарии на стене (кол-во)
    let comments: CountableItem?
    //    Число людей, кому понраилась запись
    let likes: CountableItem?
    //    Число репостов (скопировали себе на стену)
    let reposts: CountableItem?
    //    Кол-во просмотров
    let views: CountableItem?
    //    Записи со стен
    let attachments: [Attachment]?
}

//   Кол-во элементов
struct CountableItem: Decodable {
    //    Кол-во
    let count: Int
}

//   Фото записи со стены
struct Attachment: Decodable {
    let photo: Photo?
}

//   Структура фото получаемого от сервера
struct Photo: Decodable {
    //    Массив с изображениями различных размеров
    let sizes: [PhotoSize]
    //    Высота изображения из массива
    var height: Int {
        return getPropperSize().height
    }
    //    Ширина изображения из массива
    var width: Int {
        return getPropperSize().width
    }
    //    URL адрес изображения из массива
    var srcBIG: String {
        return getPropperSize().url
    }
    
    //    Получаем необходимый нам размер изображения из массива
    private func getPropperSize() -> PhotoSize {
        //        Пробегаемся по массиву и находим первое изображение с типом "x". Размер типа Х больше всго подходит для экрана телефона (спарвочник ВК)
        if let sizeX = sizes.first(where: {$0.type == "x"}) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "Wrong image", url: "Wrong image", width: 0, height: 0)
        }
    }
}

//   Структура размерности изображения
struct PhotoSize: Decodable {
    //    Тип
    let type: String
    //    Адрес
    let url: String
    //    Ширина
    let width: Int
    //    Высота
    let height: Int
}

//   Создаём протокол, где прописываем св-ва
protocol ProfileRepresentableProtocol {
    //    Айди
    var id: Int { get }
    //    Имя
    var name: String { get }
    //    Фото
    var photo: String { get }
}

//   Создаём структуру профиля человека и подписываем его под протокол выше
struct Profile: Decodable, ProfileRepresentableProtocol {
    //    Айди
    let id: Int
    //    Имя
    let firstName: String
    //    Фамилия
    let lastName: String
    //    Фото
    let photo100: String
    
    //    Возвращать будет удобочитаемое имя, которое содержит имя и фамилию
    var name: String {
        return firstName + " " + lastName
    }
    //    Возвращать будум фотографию с понятным названием
    var photo: String {
        return photo100
    }
}

//   Структура с группами
struct Group: Decodable, ProfileRepresentableProtocol {
    //    Айди
    let id: Int
    //    Название группы
    let name: String
    //    Фото группы
    let photo100: String
    
    //    Возвращать будум фотографию с понятным названием
    var photo: String {
        return photo100
    }
}
