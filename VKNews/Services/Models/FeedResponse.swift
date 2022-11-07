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
    
    var groups: [Group]
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
}

//   Кол-во элементов
struct CountableItem: Decodable {
    //    Кол-во
    let count: Int
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
