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
