//
//  NetworkService.swift
//  VKNews
//
//  Created by Rail on 01.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation

//   Получение данных из интернета через абстракцию
protocol Networking {
    //    Получение данных
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) ->())
}

//   Класс сетевого сервиса
final class NetworkService: Networking {
    
    //    Создаём объёкт типа AuthService
    private let authService: AuthService
    //    Инициализируем наш объект с синглтоном SceneDelegate
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    //    Метод будет получать данные
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> ()) {
        
        //        Проверяем наличие token
        guard let token = authService.token else { return }
        //        Создаём параметры нашего url адреса
        var allParams = params
        //        Добавим токен
        allParams["access_token"] = token
        //        Добавим версию ВК
        allParams["v"] = APi.version
        //        Получаем окончательный url адрес
        let url = self.url(from: path, params: allParams)
        //        Создаём запрос
        let request = URLRequest(url: url)
        //        Создаём задачу и передаём далее
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    //    Отдельно вынесем логику получения данных
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        //        Асинхронно в главной очереди
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    //    Соединяем все составляющие url в единый адрес
    private func url(from path: String, params: [String : String]) -> URL {
        
        var components = URLComponents()
        //        это протокол http или https
        components.scheme = APi.sheme
        //        название сайта с которого запрашиваем запрос (api.vk.com)
        components.host = APi.host
        //        будет определять к какому методу обращаться (method/users.get)
        components.path = path
        //        параметры, которые будут зависеть от api
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        //        Вернём готовый адрес
        return components.url!
    }
}
