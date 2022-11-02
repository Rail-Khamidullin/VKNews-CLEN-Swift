//
//  NetworkDataFetcher.swift
//  VKNews
//
//  Created by Rail on 02.11.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation

protocol DataFetcher {
    //   Создадим интерфейс, который будет преобразовывать полученные JSON данные в нужный нам формат
    func getFeed(response: @escaping (FeedResponse?) -> ())
}

struct NetworkDataFetcher: DataFetcher {
    
    //    Установим внешнюю зависимость, таким образом класс будет зависеть от Абстракции (protocol)
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    //    Метод который декодирует данные под структуру FeedResponse
    func getFeed(response: @escaping (FeedResponse?) -> ()) {
        
        //        Создаём параметры данных, которые необходимы для отображения (список новостейЖ запись со стен и фотографии)
        let params = ["filters" : "post, photo"]
        
        //        Вызываем get запрос данных из интеренета по нашем параметрам в url
        networking.request(path: APi.newsFeed, params: params) { (data, error) in
            
            //            Если ошибка имеется
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                response(nil)
            }
            //            Декодируем структуру FeedResponse
            let decoded = self.jsonDecoder(type: FeedResponseWrapped.self, from: data)
            //            Полученные декодированные данные передаём дальше
            response(decoded?.response)
        }
    }
    
    //    Универсальный метод декодирования данных для любой структуры
    private func jsonDecoder<T: Decodable> (type: T.Type, from: Data?) -> T? {
        
        //        Обращаемся к декодеру
        let decoder = JSONDecoder()
        //        Вызываем у него стратегию конвертации из SnakeCase, потому что у нас написано в CamelCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //        Преобразуем полученные данные в нашу структуру
        guard let data = from, let response = try? decoder.decode(type, from: data) else {
            return nil
        }
        return response
    }
}