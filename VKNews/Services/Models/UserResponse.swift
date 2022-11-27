//
//  UserResponse.swift
//  VKNews
//
//  Created by Rail on 21.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation

//   Структура, которая будет принимать идентификатор пользователя, который будет содержать массив с изображениями 
struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    //    Изображение профиля пользователя в правом углу навигейшн бара
    let photo100: String?
}
