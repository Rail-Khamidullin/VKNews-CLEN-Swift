//
//  NetworkService.swift
//  VKNews
//
//  Created by Rail on 01.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation


final class NetworkService {
    
    //    Создаём объёкт типа AuthService
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
//    Создание web адреса с помощью URLComponents
    func getFeed() {
        
        var components = URLComponents()
        // https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.131
        
        //        Проверяем наличие token
        guard let token = authService.token else { return }
        
        //        Создаём параметры api для get запроса
        let params = ["filters" : "post, photo"]
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = APi.version
        
        //        это протокол http или https
        components.scheme = APi.sheme
        //        название сайта с которого запрашиваем запрос (api.vk.com)
        components.host = APi.host
        //        будет определять к какому методу обращаться (method/users.get)
        components.path = APi.newsFeed
        //        параметры, которые будут зависеть от api
        components.queryItems = allParams.map { URLQueryItem(name: $0, value: $1) }
        
        let url = components.url!
        print(url)
    }
}
